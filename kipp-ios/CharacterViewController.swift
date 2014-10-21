//
//  CharacterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController/*, UITableViewDataSource, UITableViewDelegate, CharacterTraitUpdatedDelegate */{
    weak var student: Student?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var loadedTraitValues: [Int]!
    
    let views = ["This Week", "History"]
    
    var viewControllers: [UIViewController] = [UIViewController]()
    
    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
            }
            if let newVC = activeViewController {
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
//        
//        tableView.dataSource = self
//        tableView.delegate = self
        
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
        
//        loadedTraitValues = [Int](count: student!.characterArray.count, repeatedValue: 0)
//        loadScores()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentedControlDidChange(sender: UISegmentedControl) {
        self.activeViewController = viewControllers[sender.selectedSegmentIndex]
    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return student!.characterArray.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("characterCell") as CharacterTableViewCell
//        let trait = student!.characterArray[indexPath.row]
//        cell.characterTrait = trait
//        cell.row = indexPath.row
//        cell.score = trait.score
//        cell.delegate = self
//        return cell
//    }
//    
//    func traitScoreDidUpdate(value: Int, forRow row: Int) {
//        student!.characterArray[row].score = value
//    }
//    
    @IBAction func didTapSave(sender: UIBarButtonItem) {
        // Save to Parse
        if activeViewController == viewControllers.first {
            NSLog("Saving to parse")
            let traitVC = activeViewController! as CharacterTrackingViewController
            traitVC.saveToParse()
            
//            var scoresToSave = [PFObject]()
//            
//            for index in 0..<student!.characterArray.count {
//                let characterTrait = student!.characterArray[index]
//                if characterTrait.score != loadedTraitValues[index] {
//                    NSLog("Saving \(characterTrait.title) with value \(characterTrait.score) (Old value: \(loadedTraitValues[index]))")
//                    var characterEntry = PFObject(className: "CharacterTrait")
//                    
//                    characterEntry["type"] = characterTrait.title
//                    characterEntry["studentId"] = student!.studentId
//                    characterEntry["score"] = characterTrait.score
//                    scoresToSave.append(characterEntry)
//                }
//            }
//            if scoresToSave.count > 0 {
//                NSLog("Saving scores to parse: \(scoresToSave)")
//                ParseClient.sharedInstance.saveArrayInBulk(scoresToSave)
//            }
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func didTapCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
//
//    func loadScores() {
//        for index in 0..<student!.characterArray.count {
//            let curCharacterTrait = student!.characterArray[index]
//            
//            ParseClient.sharedInstance.getLatestCharacterScoreForWeekWithCompletion(student!.studentId, characterTrait: curCharacterTrait.title) { (characterTrait, error) -> () in
//                if characterTrait != nil {
//                    NSLog("Found \(characterTrait!.title) with score \(characterTrait!.score)")
//                    self.student!.characterArray[index].score = characterTrait!.score
//                    self.loadedTraitValues[index] = characterTrait!.score
//                } else {
//                    self.loadedTraitValues[index] = 0
//                }
//                if index == self.student!.characterArray.count - 1 {
//                    self.tableView.reloadData() // this is terrible, but don't know how to do a bulk query on this type of data...
//                }
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
