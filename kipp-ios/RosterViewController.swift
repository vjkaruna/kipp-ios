//
//  RosterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class RosterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var teacher: PFUser!
    var students: [Student] = [Student]()
    var period: Int = 1 // This should be set by caller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teacher = PFUser.currentUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher", equalTo:teacher)
        classroomQuery.whereKey("period", equalTo:period)
        classroomQuery.includeKey("students")
        
        classroomQuery.getFirstObjectInBackgroundWithBlock { (classroom, error) -> Void in
            // HACK to add more students to this class...
//            let student = PFObject(className: "Student")
//            student["firstName"] = "Bobby"
//            student["lastName"] = "Wheeler"
//            student["studentId"] = 5
//            classroom.addObject(student, forKey: "students")
//            classroom.save()
            let students = classroom.objectForKey("students") as NSArray
            self.students = Student.studentsWithArray(students)
            self.tableView.reloadData()
        }
        navigationItem.title = "Period \(period)"
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
        cell.delegate = self
        return cell
    }
    
    @IBAction func didPanCell(sender: UIPanGestureRecognizer) {
        let touchedLocation = sender.locationInView(tableView)
        let touchedIndexPath = tableView.indexPathForRowAtPoint(touchedLocation)
        if touchedIndexPath != nil {
            let touchedCell = tableView.cellForRowAtIndexPath(touchedIndexPath!)
            let velocity = sender.velocityInView(tableView)
            let translation = sender.translationInView(tableView)
            switch(sender.state) {
            case .Began, .Changed, .Ended:
                NSLog("v: \(velocity.x), t: \(translation.x)")
            default:
                NSLog("Unhandled state")
            }
        }
    }
    
    func didTapProfileImg(student: Student) {
        self.performSegueWithIdentifier("profileSegue", sender: student)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileSegue") {
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.student = sender as Student
        }
    }
}
