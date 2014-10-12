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
    
    var currentUser: PFUser!
    var students: [Student] = [Student]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentUser = PFUser.currentUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher", equalTo:currentUser)
        
        var classrooms = classroomQuery.findObjects() as [PFObject]
        
        for classroom in classrooms {
            var studentQuery = classroom.relationForKey("students").query()
            studentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                let results = objects as [PFObject]
                self.students = Student.studentsWithArray(results)
                self.tableView.reloadData()
            }

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
