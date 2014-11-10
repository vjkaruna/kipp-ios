//
//  ProfileGraphViewController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ProfileGraphViewController: UIViewController, GKLineGraphDataSource, StudentProfileChangedDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, ReasonSubmittedDelegate, UIPopoverPresentationControllerDelegate, CallMenuDelegate {

    var student: Student?

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var avatarFrame: UIView!
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var encourageButton: UIButton!
    @IBOutlet weak var celebrateButton: UIButton!
    
    var mathGraph: GKLineGraph!
    var characterPlot: CharacterPlotView!
    var circlePlot: PNCircleChart!
    
    var metricViews: [UIView] = [UIView]()
    
    var graphViewsPlotted = [UIView: Bool]()
    
    var HUD: MBProgressHUD?
    var refreshHUD: MBProgressHUD?
    
    func hudWasHidden(hud: MBProgressHUD) {
       hud.removeFromSuperview()
    }
    
    @IBAction func didTapCallButton(sender: UIBarButtonItem) {
        let menuVC = UINib(nibName: "CallMenuViewController", bundle: nil).instantiateWithOwner(self, options: nil)[0] as CallMenuViewController
        menuVC.modalPresentationStyle = UIModalPresentationStyle.Popover
        menuVC.preferredContentSize = CGSizeMake(200, 95)
        menuVC.delegate = self
        
        var popover = menuVC.popoverPresentationController
        popover?.barButtonItem = sender
        popover?.delegate = self
        self.presentViewController(menuVC, animated: true, completion: nil)
    }
    
    func dialNumber(phonestr: String) {
        let telstr = "telprompt://\(phonestr)"
        UIApplication.sharedApplication().openURL(NSURL(string:telstr)!)
    }
    
    func didTapCallNow() {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.dialNumber("510-717-8985")
    }
    
    func didTapCallLater() {
        self.dismissViewControllerAnimated(true, completion: nil)
        showReasonModal(ActionType.Call)
    }
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    @IBAction func didTapActionButton(sender: UIButton) {
        var actionType: ActionType
        if sender == encourageButton {
            actionType = .Encourage
        } else {
            actionType = .Celebrate
        }
        showReasonModal(actionType)
    }
    
    func showReasonModal(actionType: ActionType) {
        let classRosterSB = UIStoryboard(name: "ClassRoster", bundle: nil)
        let vc = classRosterSB.instantiateViewControllerWithIdentifier("reasonVC") as ReasonViewController
        vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        vc.delegate = self
        vc.actionType = actionType
        self.presentViewController(vc, animated: false, completion: nil)
    }
    
    func didTapSubmitButton(reasonString: String, actionType: ActionType) {
        self.dismissViewControllerAnimated(false, completion: nil)
        NSLog("Submitted with reason \(reasonString)")
        let action = Action(type: actionType, reason: reasonString, forDate: NSDate(), student: student!)
        ParseClient.sharedInstance.saveActionObjectWithCompletion(student!.pfObj, action: action, classroom: Classroom.currentClass()!) { (parseObj, error) -> () in
            if error != nil {
                NSLog("Error saving to Parse")
            } else {
                NSLog("Saved action to Parse")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var frame = CGRectMake(0, 40, 320, 200)
        //self.graph = GKLineGraph(frame: frame)
        
        if self.student != nil {
            self.student!.delegate = self
            self.student!.fillWeeklyProgress()
        }
        //self.graph.height = self.graph.frame.height
        //self.graph.width = self.graph.frame.width
        
        //println("h: \(self.graph.height) w: \(self.graph.width)")
        //self.graph.draw()
        
        if (student != nil) {
            studentLabel.text = student!.fullName
            let minutesAttributes = [NSForegroundColorAttributeName: UIColor.magentaColor()]
            let weeklyAttributes = [NSForegroundColorAttributeName: UIColor.greenTint()]
            let descText = NSMutableAttributedString()
            descText.appendAttributedString(NSAttributedString(string: "minutes studied -  ",attributes:minutesAttributes))
            descText.appendAttributedString(NSAttributedString(string: "weekly progress - ",attributes:weeklyAttributes))
//            legendLabel.attributedText = descText
            
            self.avatarButton.setImage(student!.profileImage, forState: .Normal)
            self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.width / 2
            self.avatarButton.clipsToBounds = true
            
            self.avatarFrame.layer.cornerRadius = self.avatarFrame.frame.size.width / 2
            self.avatarFrame.clipsToBounds = true
        }
        
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width-10, scrollView.frame.size.height)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)
        println("scrollview frame width: \(scrollView.frame.size.width), frame: \(self.view.frame.size.width)")
        
        characterPlot = CharacterPlotView(frame: scrollView.frame, studentId: student!.studentId)
//        characterPlot.frame.origin.x += scrollView.frame.size.width
        scrollView.addSubview(characterPlot)
        metricViews.append(characterPlot)
        graphViewsPlotted[characterPlot] = false
        
        mathGraph = GKLineGraph(frame: scrollView.frame)
        mathGraph.frame.origin.x += scrollView.frame.size.width
        mathGraph.dataSource = self
        scrollView.addSubview(mathGraph)
        metricViews.append(mathGraph)
        graphViewsPlotted[mathGraph] = false

        circlePlot = PNCircleChart(frame: scrollView.frame, andTotal: 100, andCurrent: 0, andClockwise: true, andShadow: true)
        circlePlot.backgroundColor = UIColor.clearColor()
        circlePlot.frame.origin.y += 25
        circlePlot.frame.origin.x += scrollView.frame.size.width * 2
//        circlePlot.chartType = .Percent
        scrollView.addSubview(circlePlot)
        metricViews.append(circlePlot)
        graphViewsPlotted[circlePlot] = false

//        var characterPlot2 = CharacterPlotView(frame: scrollView.frame, studentId: student!.studentId)
//        characterPlot2.frame.origin.x += scrollView.frame.size.width * 2
//        scrollView.addSubview(characterPlot2)
//        metricViews.append(characterPlot2)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        mathGraph.dataSource = self
        drawGraphInView(nil)
    }
    
    @IBAction func avatarTouch(sender: AnyObject) {
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)) {
            var imagePicker = UIImagePickerController()
            imagePicker.sourceType = .Camera
            imagePicker.delegate = self
            self.presentViewController(imagePicker, animated: true, completion: { () -> Void in
                
            })
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info["UIImagePickerControllerOriginalImage"] as UIImage
        picker.dismissViewControllerAnimated(true, completion: { () -> Void in
        
        })
        var finalsize = CGSizeMake(160, 160)
        UIGraphicsBeginImageContext(finalsize)
        var scale = max(finalsize.width/image.size.width, finalsize.height/image.size.height)
        var width = image.size.width * scale
        var height = image.size.height * scale
        image.drawInRect(CGRectMake((finalsize.width - width)/2, (finalsize.height - height)/2, width, height))
        var smallImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var imageData = UIImageJPEGRepresentation(smallImage, 0.1)
        ParseClient.sharedInstance.uploadImage(imageData, student: self.student!.pfObj, completion: { (profilePic, error) -> () in
            self.student!.profileImage = profilePic
            self.avatarButton.setImage(profilePic, forState: .Normal)
        })

    }
    
    
    func attendanceDidChange() {
        
    }
    func weeklyProgressDidChange() {
        //self.graph.reset()
//        self.mathGraph.dataSource = self
//        self.mathGraph.lineWidth = 4.0
//        self.mathGraph.draw()
//        if self.student != nil && self.student?.weeklyProgress? != nil && self.student?.weeklyProgress?.count > 0 {
////            self.topicLabel.text = "Current Topic: \(self.student!.weeklyProgress![self.student!.weeklyProgress!.count-1].topic)"
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfLines() -> Int {
        return 2
    }
    
    func colorForLineAtIndex(index: Int) -> UIColor! {
        var mcolors = [UIColor]()
        mcolors.append(UIColor.magentaColor())
        mcolors.append(UIColor.greenTint())
        return mcolors[index] as UIColor!
    }
    
    func valuesForLineAtIndex(index: Int) -> [AnyObject]! {
        var data = [Int]()

        if (self.student != nil && self.student!.weeklyProgress != nil && self.student!.weeklyProgress?.count > 0 ) {
            for progress in self.student!.weeklyProgress! {
                if index == 0 {
                    data.append(progress.minutes)
                } else {
                    data.append(Int(progress.weeklyProgress))
                }
            }
            
        } else {
            // default data
            if (index == 0) {
               data = [2,30,40,70,50,40,80,120,50,3,40,60,90]
            } else {
               data = [12,36,62,91,84,75,79,96,57,47,39,56,75]
            }
        }
        return data
    
    }
    
    func animationDurationForLineAtIndex(index: Int) -> CFTimeInterval {
        return CFTimeInterval(3)
    }
    
    func titleForLineAtIndex(index: Int) -> String! {
        return "\(index)"
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.scrollView.frame.size.width
        let page = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1
        drawGraphInView(page)
    }
    
    func drawGraphInView(inPage: Int?) {
        var redrawGraph = false
        if inPage != nil && self.pageControl.currentPage != inPage! {
            self.pageControl.currentPage = inPage!
            redrawGraph = true
        } else if inPage == nil {
            redrawGraph = true
        }
        if redrawGraph {
//            self.pageControl.currentPage = page
            if metricViews[self.pageControl.currentPage] == characterPlot && !graphViewsPlotted[characterPlot]! {
                NSLog("Calling plotGraph()")
                characterPlot.plotGraph()
                graphViewsPlotted[characterPlot] = true
            } else if metricViews[self.pageControl.currentPage] == mathGraph && !graphViewsPlotted[mathGraph]! {
                NSLog("Calling math draw")
                mathGraph.draw()
                graphViewsPlotted[mathGraph] = true
            } else if metricViews[self.pageControl.currentPage] == circlePlot && !graphViewsPlotted[circlePlot]! {
                circlePlot.current = 15
                circlePlot.strokeChart()
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "plotSegue") {
            var plotVC = segue.destinationViewController as SpiderViewController
            plotVC.studentId = student!.studentId
        }
    }


}
