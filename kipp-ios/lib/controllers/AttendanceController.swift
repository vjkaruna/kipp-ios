//
//  AttendanceController.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPopoverPresentationControllerDelegate {
    @IBOutlet weak var attendanceTable: UITableView!
    var students: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getClassroom()
        installPanGestureRecognizer()
    }
    
    @IBAction func onSelectClass(sender: AnyObject) {
        selectClass()
    }
    func selectClass() {
        var popoverContent = UIStoryboard(name: "ClassroomSelection", bundle: nil).instantiateViewControllerWithIdentifier("ClassroomSelection") as UIViewController
        
        var nav = UINavigationController(rootViewController: popoverContent)
        nav.modalPresentationStyle = UIModalPresentationStyle.Popover
        var popover = nav.popoverPresentationController
        popoverContent.preferredContentSize = CGSizeMake(340,500)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRectMake(20,70,0,0)
        
        self.presentViewController(nav, animated: true, completion: nil)
    }
    
    func adaptivePresentationStyleForPresentationController(PC: UIPresentationController!) -> UIModalPresentationStyle {
        // This *forces* a popover to be displayed on the iPhone
        return .None
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = attendanceTable.dequeueReusableCellWithIdentifier("attendanceCell") as AttendanceViewCell
        cell.studentNameLabel.text = students?[indexPath.row].firstName
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func getClassroom() {
        ParseClient.sharedInstance.findClassroomsWithCompletion() { (classrooms: [Classroom]?, error: NSError?) -> Void in
            if classrooms != nil && classrooms?.count > 0 {
                self.students = classrooms![0].students
                self.attendanceTable.reloadData()
            }
            else {
                NSLog("error getting classroom data from Parse")
            }
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func installPanGestureRecognizer() {
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCellDrag:")
        attendanceTable.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    var draggedCell: AttendanceViewCell?
    
    func onCellDrag(panGestureRecognizer: UIPanGestureRecognizer) {
        let magicThreshold:CGFloat = 144
        let indexPath = attendanceTable.indexPathForRowAtPoint(panGestureRecognizer.locationInView(attendanceTable))
        if indexPath != nil {
            if panGestureRecognizer.state == UIGestureRecognizerState.Began {
                self.draggedCell = (attendanceTable.cellForRowAtIndexPath(indexPath!)) as? AttendanceViewCell
            } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
                draggedCell?.moveCell(panGestureRecognizer.translationInView(attendanceTable).x)
            } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
                var amount = panGestureRecognizer.translationInView(attendanceTable).x
                if (abs(amount) < magicThreshold) {
                    self.draggedCell?.moveCell(0)
                    UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: { () -> Void in
                        self.view.layoutIfNeeded()
                        return Void()
                        }, completion: nil)
                } else {
                    
                    
                    let offScreenAmount = 3 * panGestureRecognizer.translationInView(attendanceTable).x
                    self.draggedCell?.moveCell(offScreenAmount)
                    UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(), animations: { () -> Void in
                        self.view.layoutIfNeeded()
                        return ()
                        }, completion: { (bool:Bool) -> Void in
                            if amount > magicThreshold {
                                self.markStudent(indexPath!, type: AttendanceType.Present)
                            } else {
                                self.markStudent(indexPath!, type: AttendanceType.Absent)
                            }
                            return ()
                    })
                    
                }
            }
        }
    }
    
    func markStudent(indexPath: NSIndexPath, type: AttendanceType) {
        // Actually Mark the student
        var student = students?.removeAtIndex(indexPath.row)
        student?.markAttendanceForType(type)
        self.attendanceTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
