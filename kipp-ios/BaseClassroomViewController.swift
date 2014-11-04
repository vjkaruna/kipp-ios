//
//  BaseClassroomViewController.swift
//  kipp-ios
//
//  Created by vli on 11/3/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class BaseClassroomViewController: UIViewController {
    weak var classroom: Classroom!
    
    func loadClassroom() {
        var classroom = Classroom.currentClass()
        if classroom == nil {
            Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
                if classroom != nil {
                    self.classroom = classroom
                    self.classroomLoaded()
//                    self.tableView.reloadData()
//                    self.navigationItem.title = "Period \(classroom!.period): Character"
//                    NSLog(classroom?.title ?? "nil")
                }
                else {
                    NSLog("error getting classroom data from Parse")
                }
            }
        } else {
            self.classroom = classroom
            classroomLoaded()
//            self.tableView.reloadData()
//            self.navigationItem.title = "Period \(classroom!.period): Character"
        }
    }

    func classroomLoaded() {
        NSLog("Classroom loaded: Period \(classroom.period)")
    }
}
