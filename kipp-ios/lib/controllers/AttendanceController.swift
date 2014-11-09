//
//  AttendanceController.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceController: BaseClassroomViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate, MGSwipeTableCellDelegate, StudentProfileChangedDelegate {
    @IBOutlet weak var attendanceTable: UITableView!

    @IBOutlet weak var contentView: UIView!
    var students: [Student]?
    var emptyView: EmptyDataView!
    
    var attendanceComplete: Bool = false
    
    var tardyCounts = [Int: Int]()
    var absentCounts = [Int: Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        attendanceTable.delegate = self
        attendanceTable.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        attendanceTable.registerNib(nib, forCellReuseIdentifier: "studentCell")
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)
        
        attendanceTable.estimatedRowHeight = 100
        attendanceTable.rowHeight = UITableViewAutomaticDimension
        loadClassroom()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        loadClassroom()
    }
    
    func loadDataOrEmptyState() {
        if students != nil {
            if attendanceComplete || students!.count == 0 {
                emptyView.hidden = false
                attendanceTable.hidden = true
                emptyView.type = .Attendance
            } else {
                attendanceTable.hidden = false
                emptyView.hidden = true
                //            attendanceTable.reloadData()
            }
        }
    }
    
    override func classroomLoaded() {
        navigationItem.title = "Period \(classroom!.period): Attendance"
        for student in classroom.students {
            student.delegate = self
            student.fillAttendanceState()
        }
//        loadDataOrEmptyState()
//        attendanceTable.reloadData()
    }

    func attendanceCountsDidChange(studentId: Int, absentCount: Int, tardyCount: Int) {
        absentCounts[studentId] = absentCount
        tardyCounts[studentId] = tardyCount
        NSLog("Attendance count changed: \(absentCounts.count), \(tardyCounts.count) / \(classroom.students.count)")
        if absentCounts.count == classroom.students.count && tardyCounts.count == classroom.students.count {
            if students == nil {
                for student in classroom.students {
                    if student.attendance == nil {
                        students?.append(student)
                    }
                }
                if students == nil {
                    students = []
                }
                loadDataOrEmptyState()
                attendanceTable.reloadData()
            }
        }
    }
    
    func attendanceDidChange() {
        
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = students![indexPath.row]
        cell.student = student
        cell.showAttendanceState = false
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
        
        cell.metadataLabel.attributedText = getAttendanceMetadataText(student.studentId)
        
        cell.setNeedsDisplay()
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students?.count ?? 0
    }
    
    func createRightButtons() -> NSArray {
        var absentButton = MGSwipeButton(title: "", icon: UIImage(named: "x"), backgroundColor: UIColor.myRedColor()) { (cell) -> Bool in
            NSLog("Tapped absent for \(cell)")
            let indexPath = self.attendanceTable.indexPathForCell(cell)!
            self.markStudent(indexPath, cell: cell as StudentTableViewCell, type: .Absent)
            return true
        }
        absentButton.setPadding(CGFloat(25))
        var lateButton = MGSwipeButton(title: "", icon: UIImage(named: "alarm"), backgroundColor: UIColor.myYellow()) { (cell) -> Bool in
            NSLog("Tapped late for \(cell)")
            let indexPath = self.attendanceTable.indexPathForCell(cell)!
            self.markStudent(indexPath, cell: cell as StudentTableViewCell, type: .Tardy)
            return true
        }
        return [absentButton, lateButton]
    }
    
    func createLeftButtons() -> NSArray {
        let button = MGSwipeButton(title: "", icon: UIImage(named: "checkmark-green"), backgroundColor: UIColor.greenTint()) { (cell) -> Bool in
            NSLog("Tapped present for \(cell)")
            let indexPath = self.attendanceTable.indexPathForCell(cell)!
            self.markStudent(indexPath, cell: cell as StudentTableViewCell, type: .Present)
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
    
    func markStudent(indexPath: NSIndexPath, cell: StudentTableViewCell, type: AttendanceType) {
        // Actually Mark the student
//        let indexPath = attendanceTable.indexPathForCell(cell)!
        var student = students?.removeAtIndex(indexPath.row)
        student?.markAttendanceForType(type)
        if type == AttendanceType.Absent {
            absentCounts[student!.studentId] = absentCounts[student!.studentId]! + 1
        } else if type == AttendanceType.Tardy {
            tardyCounts[student!.studentId] = tardyCounts[student!.studentId]! + 1
        }
        
        cell.attendanceDidChange()
        
        attendanceTable.beginUpdates()
        attendanceTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        attendanceTable.endUpdates()
        
        if students!.count == 0 {
            attendanceComplete = true
        }
        
        loadDataOrEmptyState()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "editAttendanceSegue") {
            var editVC = segue.destinationViewController as AttendanceEditViewController
            editVC.tardyCounts = self.tardyCounts
            editVC.absentCounts = self.absentCounts
        }
    }
}
