//
//  CharacterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController, ReasonSubmittedDelegate {
    weak var student: Student?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var encourageButton: UIButton!
    @IBOutlet weak var celebrateButton: UIButton!
    @IBOutlet weak var callLaterButton: UIButton!
    
    @IBOutlet weak var menuHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var loadedTraitValues: [Int]!
    
    var expandedMenu = false
    
    let views = ["This Week", "History"]
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    let MENU_COLLAPSED_HEIGHT: CGFloat = 55
    let MENU_EXPANDED_HEIGHT: CGFloat = 270
    
    let classRosterSB = UIStoryboard(name: "ClassRoster", bundle: nil)
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
                if newVC == viewControllers.last {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: nil, action: "didTapCancel:")
                } else {
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Save, target: nil, action: "didTapSave:")
                }
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleHeight | .FlexibleWidth
                newVC.view.frame = self.contentView.bounds
                self.contentView.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        
        for index in 0..<views.count {
            segmentedControl.setTitle(views[index], forSegmentAtIndex: index)
        }
        
        segmentedControl.selectedSegmentIndex = 0
        
        let trackingVC = self.storyboard!.instantiateViewControllerWithIdentifier("CharacterTrackingVC") as CharacterTrackingViewController
        trackingVC.student = student
        
        let dummyVC = self.storyboard!.instantiateViewControllerWithIdentifier("HexViewController") as UIViewController
//        dummyVC.student = student
        
        viewControllers = [trackingVC, dummyVC]
        
        self.activeViewController = viewControllers.first
//        blurView.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        self.activeViewController = viewControllers[sender.selectedSegmentIndex]
    }
    
    @IBAction func didTapSave(sender: UIBarButtonItem) {
        // Save to Parse
        if activeViewController == viewControllers.first {
            NSLog("Saving to parse")
            let traitVC = activeViewController! as CharacterTrackingViewController
            traitVC.saveToParse()
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapAlert(sender: UIButton) {
        // TODO bring up modal here
        var actionType: ActionType
        if sender == encourageButton {
            actionType = .Encourage
//            let action = Action(type: .Encourage, reason: "for testing encourage", forDate: 1.daysFromNow)
//            ParseClient.sharedInstance.saveActionObjectWithCompletion(student!.pfObj, action: action) { (parseObj, error) -> () in
//                if error != nil {
//                    NSLog("Error saving to Parse")
//                } else {
//                    NSLog("Saved to Parse")
//                }
//            }
        } else if sender == celebrateButton {
            actionType = .Celebrate
//            let action = Action(type: .Celebrate, reason: "for testing celebrate", forDate: 2.daysFromNow)
//            ParseClient.sharedInstance.saveActionObjectWithCompletion(student!.pfObj, action: action) { (parseObj, error) -> () in
//                if error != nil {
//                    NSLog("Error saving to Parse")
//                } else {
//                    NSLog("Saved to Parse")
//                }
//            }
        } else {
            actionType = .Call
//            let action = Action(type: .Call, reason: "for testing call", forDate: 3.daysFromNow)
//            ParseClient.sharedInstance.saveActionObjectWithCompletion(student!.pfObj, action: action) { (parseObj, error) -> () in
//                if error != nil {
//                    NSLog("Error saving to Parse")
//                } else {
//                    NSLog("Saved to Parse")
//                }
//            }
        }
        showReasonModal(actionType)
    }

    func showReasonModal(actionType: ActionType) {
        let vc = classRosterSB.instantiateViewControllerWithIdentifier("reasonVC") as ReasonViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        vc.delegate = self
        vc.actionType = actionType
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        switch(sender.state) {
        case .Began, .Changed:
            let translation = sender.translationInView(self.view)
            NSLog("Began/Changed: \(translation.y)")
            // Swiping down
            if translation.y > 0 && expandedMenu {
                let resizeVal = self.MENU_EXPANDED_HEIGHT - translation.y
                if resizeVal > self.MENU_COLLAPSED_HEIGHT {
                    self.menuHeightConstraint.constant = resizeVal
                } else {
                    collapseMenu()
                }
            } else if translation.y < 0 && !expandedMenu {
                let resizeVal = self.MENU_COLLAPSED_HEIGHT + (-translation.y)
                if resizeVal < self.MENU_EXPANDED_HEIGHT {
                    self.menuHeightConstraint.constant = resizeVal
                } else {
                    expandMenu()
                }
            }
        case .Ended, .Cancelled:
            NSLog("Cancelled")
            let velocity = sender.velocityInView(self.view)
            NSLog("Y Velocity: \(velocity.y)")
            if velocity.y > 0 && expandedMenu {
                // swipe down
                collapseMenu()
            } else if velocity.y < 0 && !expandedMenu {
                // swiped up
                expandMenu()
            } else {
                // no vertical swipe detected
            }
        default:
            NSLog("event not handled")
        }
    }
    
    func expandMenu() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.menuHeightConstraint.constant = self.MENU_EXPANDED_HEIGHT
            self.blurView.layoutIfNeeded()
            }, completion: nil)
        expandedMenu = true
    }
    
    func collapseMenu() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.menuHeightConstraint.constant = self.MENU_COLLAPSED_HEIGHT

            self.blurView.layoutIfNeeded()
            }, completion: nil)
        expandedMenu = false
    }
    
    func didTapSubmitButton(reasonString: String) {
        self.dismissViewControllerAnimated(false, completion: nil)
        NSLog("Submitted with reason \(reasonString)")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
