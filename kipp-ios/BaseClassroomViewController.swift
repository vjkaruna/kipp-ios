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
    var classroomReloadNeeded = true
    
    func loadClassroom() {
        classroomReloadNeeded = true
        _loadClassroom()
    }
    func _loadClassroom() {
        var classroom = Classroom.currentClass()
        if classroom == nil {
            Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
                if classroom != nil {
                    self.classroom = classroom
                    self.classroomLoaded()
                }
                else {
                    NSLog("error getting classroom data from Parse")
                }
            }
        } else {
            self.classroom = classroom
            classroomLoaded()
        }
    }

    func classroomLoaded() {
        classroomReloadNeeded = false
        NSLog("Classroom loaded: Period \(classroom.period)")
    }
}
