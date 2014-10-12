//
//  RosterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var teacher: PFUser!
    var students: [Student] = [Student]()
    var period: Int = 1 // This should be set by caller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teacher = PFUser.currentUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        
//        var classroomQuery = PFQuery(className: "Classroom")
//        classroomQuery.whereKey("teacher", equalTo:teacher)
//        classroomQuery.whereKey("period", equalTo:period)
//        
//        var classrooms = classroomQuery.findObjects() as [PFObject]
//        
//        for classroom in classrooms {
//            var studentQuery = classroom.relationForKey("students").query()
//            studentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
//                let results = objects as [PFObject]
//                self.students = Student.studentsWithArray(results)
//                self.tableView.reloadData()
//            }
//        }
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher", equalTo:teacher)
        classroomQuery.whereKey("period", equalTo:period)
        classroomQuery.includeKey("students")
        
        classroomQuery.getFirstObjectInBackgroundWithBlock { (classroom, error) -> Void in
//            let student = PFObject(className: "Student")
//            student["firstName"] = "Sally"
//            student["lastName"] = "Hitchens"
//            student["studentId"] = 4
//            classroom.addObject(student, forKey: "students")
//            classroom.save()
            let students = classroom.objectForKey("students") as NSArray
            self.students = Student.studentsWithArray(students)
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = students[indexPath.row]
        cell.student = student
        return cell
    }
}
