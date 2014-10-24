//
//  AttendanceViewController.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate {
    var students: [Studentz]?

    @IBOutlet weak var attendanceTable: UITableView!
    
    var draggedCell: AttendanceTableViewCell?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if students != nil {
            println(students!.count)
        }
        
        return students?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var student = students![indexPath.row]
        var cell = attendanceTable.dequeueReusableCellWithIdentifier("attendanceCell") as AttendanceTableViewCell
        cell.setup(student, mark: {
            (status) -> Void in
            self.markStudent(indexPath, status: status)
        })
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attendanceTable.layoutMargins = UIEdgeInsetsZero
        self.students = Studentz.students()
        attendanceTable.reloadData()
        installPanGestureRecognizer()
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func installPanGestureRecognizer() {
        var panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onCellDrag:")
        attendanceTable.addGestureRecognizer(panGestureRecognizer)
        panGestureRecognizer.delegate = self
    }
    
    func markStudent(indexPath: NSIndexPath, status: Status) {
        students?[indexPath.row].mark(status)
        students?.removeAtIndex(indexPath.row)
        if (status == Status.Tardy || status == Status.Late) {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.attendanceTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            
        } else {
            UIView.animateWithDuration(1, animations: { () -> Void in
                self.attendanceTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            })
            
        }
        attendanceTable.reloadData()
    }
    
    func onCellDrag(panGestureRecognizer: UIPanGestureRecognizer) {
        let indexPath = attendanceTable.indexPathForRowAtPoint(panGestureRecognizer.locationInView(attendanceTable))
        if panGestureRecognizer.state == UIGestureRecognizerState.Began {
            self.draggedCell = (attendanceTable.cellForRowAtIndexPath(indexPath!)) as? AttendanceTableViewCell
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Changed {
            draggedCell?.move(panGestureRecognizer.translationInView(attendanceTable).x)
        } else if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            var amount = panGestureRecognizer.translationInView(attendanceTable).x
            if (abs(amount) < 144) {
                self.draggedCell?.move(0)
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 10, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    return Void()
                    }, completion: nil)
            } else {
                self.draggedCell?.move(3 * panGestureRecognizer.translationInView(attendanceTable).x)
                UIView.animateWithDuration(0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: UIViewAnimationOptions(), animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    return Void()
                    }, completion: { (bool:Bool) -> Void in
                        self.draggedCell?.present()
                        return Void()
                })
                
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
