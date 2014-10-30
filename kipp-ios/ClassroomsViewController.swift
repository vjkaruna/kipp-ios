//
//  ClassroomsViewController.swift
//  kipp-ios
//
//  Created by vli on 10/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ClassroomsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var classes: [Classroom]?
    var onClose: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        ParseClient.sharedInstance.findClassroomsWithCompletion() { (classrooms: [Classroom]?, error: NSError?) -> Void in
            if classrooms != nil {
                self.classes = classrooms
                self.tableView.reloadData()
            }
            else {
                NSLog("error getting classroom data from Parse")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("classroomCell") as ClassroomTableViewCell
        let classroom = classes![indexPath.row] as Classroom
        cell.classLabel.text = "Period \(classroom.period): \(classroom.subject)"
        if classroom.parseId == Classroom.currentClass()!.parseId {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if classes != nil {
            return classes!.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        Classroom.setCurrentClass(classes![indexPath.row] as Classroom)
        tableView.reloadData()
        self.onClose?()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "rosterSegue") {
//            var rosterVC = segue.destinationViewController as RosterViewController
//            rosterVC.classroom =
//        }
//    }

}
