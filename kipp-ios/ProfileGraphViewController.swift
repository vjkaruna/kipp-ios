//
//  ProfileGraphViewController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ProfileGraphViewController: UIViewController, UIImagePickerControllerDelegate, MBProgressHUDDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, ReasonSubmittedDelegate, UIPopoverPresentationControllerDelegate, CallMenuDelegate {

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
    var barGraph: PNBarChart!
    
    var progressTitle: UILabel!
    var metricViews: [UIView] = [UIView]()
    
    var graphViewsPlotted = [UIView: Bool]()
    
    var currentProgress: Int?
    
    var pastMonthAttendance: [AttendanceType: Int]?
    
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
        
        if self.student != nil {
            studentLabel.text = student!.fullName
            
            self.avatarButton.setImage(student!.profileImage, forState: .Normal)
            self.avatarButton.layer.cornerRadius = self.avatarButton.frame.size.width / 2
            self.avatarButton.clipsToBounds = true
            
            self.avatarFrame.layer.cornerRadius = self.avatarFrame.frame.size.width / 2
            self.avatarFrame.clipsToBounds = true
        }
        
        fillWeeklyProgress()
        fillMonthAttendance()
        
        scrollView.delegate = self
        scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width-10, scrollView.frame.size.height)
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * 3, scrollView.frame.size.height)
        println("scrollview frame width: \(scrollView.frame.size.width), frame: \(self.view.frame.size.width)")
        
        // Add character map
        characterPlot = CharacterPlotView(frame: scrollView.frame, studentId: student!.studentId)
        scrollView.addSubview(characterPlot)
        metricViews.append(characterPlot)
        graphViewsPlotted[characterPlot] = false
        
        // Add circle progress chart
        progressTitle = UILabel(frame: CGRectMake(0, 5, self.view.frame.size.width-10, 70))
        progressTitle.frame.origin.x += scrollView.frame.size.width
        progressTitle.numberOfLines = 0
        progressTitle.textColor = UIColor.darkBlue()
        progressTitle.textAlignment = .Center
        progressTitle.lineBreakMode = .ByWordWrapping
        scrollView.addSubview(progressTitle)
        
        circlePlot = PNCircleChart(frame: CGRectMake(0, 40, self.view.frame.size.width-10, scrollView.frame.size.height-60), andTotal: 100, andCurrent: 0, andClockwise: true, andShadow: true)
        circlePlot.backgroundColor = UIColor.clearColor()
        circlePlot.strokeColor = UIColor.greenTint()
        circlePlot.strokeColorGradientStart = UIColor.darkBlue()
        circlePlot.frame.origin.x += scrollView.frame.size.width
//        circlePlot.strokeChart()
        scrollView.addSubview(circlePlot)
        metricViews.append(circlePlot)
        graphViewsPlotted[circlePlot] = false
        
        // Attendance bar graph
        var barTitle = UILabel(frame: CGRectMake(0, 5, self.view.frame.size.width-10, 70))
        barTitle.frame.origin.x += scrollView.frame.size.width * 2
        barTitle.numberOfLines = 0
        barTitle.textColor = UIColor.darkBlue()
        barTitle.text = "Attendance in the Last 30 Days"
        barTitle.textAlignment = .Center
        barTitle.lineBreakMode = .ByWordWrapping
        scrollView.addSubview(barTitle)
        
        barGraph = PNBarChart(frame: CGRectMake(10, 70, self.view.frame.size.width-10, scrollView.frame.size.height))
        barGraph.frame.origin.x += scrollView.frame.size.width * 2
        barGraph.backgroundColor = UIColor.clearColor()
        barGraph.barBackgroundColor = UIColor.clearColor()
        barGraph.labelMarginTop = 5.0;
        barGraph.xLabels = ["Absences", "Tardies"]
        barGraph.strokeColors = [UIColor.myRedColor(), UIColor.myYellow()]
        
        // Adding gradient
        barGraph.barColorGradientStart = UIColor.kippBlue()
        scrollView.addSubview(barGraph)
        metricViews.append(barGraph)
        graphViewsPlotted[barGraph] = false
        
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
    
    func fillMonthAttendance() {
        ParseClient.sharedInstance.getAttendanceCountsForRange(self.student!.studentId, startDate: (-30).daysFromNow, endDate: NSDate()) { (counts, error) -> () in
            if error == nil {
                self.pastMonthAttendance = counts
                let absentCount = counts![AttendanceType.Absent]
                let tardyCount = counts![AttendanceType.Tardy]
                self.barGraph.yValues = [absentCount!, tardyCount!]
                if self.graphViewsPlotted[self.barGraph]! {
                    self.barGraph.strokeChart()
                }
            }
        }
    }
    
    func fillWeeklyProgress() {
        ParseClient.sharedInstance.getProgressWithCompletion(self.student!.studentId, completion: { (progressArray, error) -> () in
            if error == nil {
                let progress = progressArray.last
                self.progressTitle.text = "Week \(progress!.week) Progress\nCurrent Topic • \(progress!.topic)"
                self.currentProgress = Int(progress!.weeklyProgress)
                
                if self.graphViewsPlotted[self.circlePlot]! { // if the graph has been 'plotted' without a value, re-draw the graph with values
                    self.circlePlot.strokeChart()
                }
            }
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.scrollView.frame.size.width
        let page = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2.0) / pageWidth)) + 1
        drawGraphInView(page)
    }
    
    @IBAction func changePage(sender: UIPageControl) {
        let page = sender.currentPage
        
        // update the scroll view to the appropriate page
        var frame = scrollView.frame;
        frame.origin.x = frame.size.width * CGFloat(page)
        frame.origin.y = 0
        scrollView.scrollRectToVisible(frame, animated: true)
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
            } else if metricViews[self.pageControl.currentPage] == barGraph && !graphViewsPlotted[barGraph]! {
                NSLog("Calling attendance draw")
                if pastMonthAttendance != nil {
                    barGraph.strokeChart()
                }
                graphViewsPlotted[barGraph] = true
            } else if metricViews[self.pageControl.currentPage] == circlePlot && !graphViewsPlotted[circlePlot]! {
                if currentProgress != nil {
                    circlePlot.current = currentProgress!
                    circlePlot.strokeChart()
                }
                graphViewsPlotted[circlePlot] = true
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
