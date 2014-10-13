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
    var classroom: Classroom!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.reloadData()
        
        navigationItem.title = "Period \(classroom.period)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classroom.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = classroom.students[indexPath.row]
        cell.student = student
        cell.delegate = self
        return cell
    }
    
    @IBAction func didPanCell(sender: UIPanGestureRecognizer) {
        let touchedLocation = sender.locationInView(tableView)
        let touchedIndexPath = tableView.indexPathForRowAtPoint(touchedLocation)
        if touchedIndexPath != nil {
            let touchedCell = tableView.cellForRowAtIndexPath(touchedIndexPath!) as StudentTableViewCell
            let velocity = sender.velocityInView(tableView)
            let translation = sender.translationInView(tableView)
            switch(sender.state) {
            case .Began, .Changed, .Ended:
                NSLog("v: \(velocity.x), t: \(translation.x)")
                touchedCell.xPanLocation = translation.x
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
