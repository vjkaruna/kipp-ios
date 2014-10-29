//
//  AttendanceController.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate, MGSwipeTableCellDelegate {
    @IBOutlet weak var attendanceTable: UITableView!
    var students: [Student]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadClassroom()
        
        attendanceTable.delegate = self
        attendanceTable.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        attendanceTable.registerNib(nib, forCellReuseIdentifier: "studentCell")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadClassroom()
    }
    
    func loadClassroom() {
        var classroom = Classroom.currentClass()
        if classroom == nil {
            Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
                if classroom != nil {
                    self.students = classroom?.students
                    self.attendanceTable.reloadData()
                    self.navigationItem.title = "Period \(classroom!.period): Attendance"
                    NSLog(classroom?.title ?? "nil")
                }
                else {
                    NSLog("error getting classroom data from Parse")
                }
            }
        } else {
            self.students = classroom?.students
            self.attendanceTable.reloadData()
            self.navigationItem.title = "Period \(classroom!.period): Attendance"
        }
//        Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
//            if classroom != nil {
//                self.students = classroom!.students
//                self.navigationItem.title = "Period \(classroom!.period)"
//                self.attendanceTable.reloadData()
//                
//                NSLog(classroom?.title ?? "nil")
//            }
//            else {
//                NSLog("error getting classroom data from Parse")
//            }
//        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = students![indexPath.row]
        cell.student = student
        cell.profileDelegate = self
        cell.delegate = self
        cell.rightButtons = createRightButtons()
        cell.leftButtons = createLeftButtons()
        
        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        
        cell.leftExpansion.fillOnTrigger = true
        cell.rightExpansion.fillOnTrigger = true
        cell.rightExpansion.buttonIndex = 0
        cell.leftExpansion.buttonIndex = 0
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func createRightButtons() -> NSArray {
        var absentButton = MGSwipeButton(title: "", icon: UIImage(named: "x"), backgroundColor: UIColor.myRedColor()) { (cell) -> Bool in
            NSLog("Tapped absent for \(cell)")
            self.markStudent(cell, type: .Absent)
            return true
        }
        absentButton.setPadding(CGFloat(25))
        var lateButton = MGSwipeButton(title: "", icon: UIImage(named: "alarm"), backgroundColor: UIColor.myYellow()) { (cell) -> Bool in
            NSLog("Tapped late for \(cell)")
            self.markStudent(cell, type: .Tardy)
            return true
        }
        return [absentButton, lateButton]
    }
    
    func createLeftButtons() -> NSArray {
        let button = MGSwipeButton(title: "", icon: UIImage(named: "checkmark-green"), backgroundColor: UIColor.greenTint()) { (cell) -> Bool in
            NSLog("Tapped present for \(cell)")
            self.markStudent(cell, type: .Present)
            return true
        }
        button.setPadding(CGFloat(25))
        return [button]
    }
    
    func didTapProfileImg(student: Student) {
        NSLog("Tapped profile")
    }
    
    func markStudent(cell: UITableViewCell, type: AttendanceType) {
        // Actually Mark the student
        let indexPath = attendanceTable.indexPathForCell(cell)!
        var student = students?.removeAtIndex(indexPath.row)
        student?.markAttendanceForType(type)
        self.attendanceTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
}
