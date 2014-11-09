//
//  AttendanceEditViewController.swift
//  kipp-ios
//
//  Created by vli on 10/29/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate, MGSwipeTableCellDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var students: [Student]?
    var emptyView: EmptyDataView!
    
    var tardyCounts: [Int: Int]!
    var absentCounts: [Int: Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "studentCell")
        
//        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
//        emptyView.hidden = true
//        contentView.addSubview(emptyView)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadClassroom()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadClassroom()
    }
    
    @IBAction func tappedDone(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadDataOrEmptyState() {
        if students!.count > 0 {
            tableView.hidden = false
//            emptyView.hidden = true
            tableView.reloadData()
        } else {
//            emptyView.hidden = false
            tableView.hidden = true
//            emptyView.type = .Attendance
        }
    }
    
    func loadClassroom() {
        var classroom = Classroom.currentClass()
        if classroom == nil {
            Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
                if classroom != nil {
                    self.students = classroom?.students
                    self.loadDataOrEmptyState()
                    NSLog(classroom?.title ?? "nil")
                }
                else {
                    NSLog("error getting classroom data from Parse")
                }
            }
        } else {
            self.students = classroom?.students
            loadDataOrEmptyState()
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = students![indexPath.row]
        cell.student = student
        cell.showAttendanceState = true
        cell.profileDelegate = self
        cell.delegate = self
        cell.rightButtons = createRightButtons()
        cell.leftButtons = createLeftButtons()
        
        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.metadataLabel.text = ""
        cell.leftExpansion.fillOnTrigger = true
        cell.rightExpansion.fillOnTrigger = true
        cell.rightExpansion.buttonIndex = 0
        cell.leftExpansion.buttonIndex = 0
        
        cell.metadataLabel.attributedText = getAttendanceMetadataText(student.studentId)
        return cell
    }
    
    func getAttendanceMetadataText(studentId: Int) -> NSAttributedString {
        let tardyAttributes = [NSForegroundColorAttributeName: UIColor.myRedColor()]
        let absentAttributes = [NSForegroundColorAttributeName: UIColor.greenTint()]
        let neutralAttributes = [NSForegroundColorAttributeName: UIColor.grayColor()]
        let charText = NSMutableAttributedString()
        
        let tardyCount = tardyCounts[studentId]!
        let absentCount = absentCounts[studentId]!
        
        if tardyCount == 0 && absentCount == 0 {
            return NSAttributedString(string: "Perfect attendance this week!", attributes: neutralAttributes)
        }
        
        if tardyCount > 0 {
            charText.appendAttributedString(NSAttributedString(string: "\(tardyCount) tardies", attributes: tardyAttributes))
        }
        if absentCount > 0 {
            if charText.length > 0 {
                charText.appendAttributedString(NSAttributedString(string: "\n\(absentCount) absences", attributes: absentAttributes))
            } else {
                charText.appendAttributedString(NSAttributedString(string: "\(absentCount) absences", attributes: absentAttributes))
            }
        }
        
        return charText
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
        let parentSB = UIStoryboard(name: "ParentCalls", bundle: nil)
        let profileVC = parentSB.instantiateViewControllerWithIdentifier("studentProfileC") as ProfileGraphViewController
        
        profileVC.student = student
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    func markStudent(cell: UITableViewCell, type: AttendanceType) {
        // Actually Mark the student
        let indexPath = tableView.indexPathForCell(cell)!
        let student = students?[indexPath.row]
        
        // Add to attendance count; if we are updating the attendance type, subtract one from the previous type
        if type == AttendanceType.Absent {
            absentCounts[student!.studentId] = absentCounts[student!.studentId]! + 1
            
            if student!.attendance? == AttendanceType.Tardy {
                tardyCounts[student!.studentId] = tardyCounts[student!.studentId]! - 1
            }
        } else if type == AttendanceType.Tardy {
            tardyCounts[student!.studentId] = tardyCounts[student!.studentId]! + 1
            
            if student!.attendance? == AttendanceType.Absent {
                absentCounts[student!.studentId] = absentCounts[student!.studentId]! - 1
            }
        }
        
        student?.markAttendanceForType(type)
        tableView.reloadData()
    }
}