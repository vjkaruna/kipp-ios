//
//  Student.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class Student: NSObject {
    var firstName, lastName: String!
    var studentId: Int!
    
    init(obj: PFObject) {
        self.firstName = obj["firstName"] as NSString
        self.lastName = obj["lastName"] as NSString
        self.studentId = obj["studentId"] as NSInteger
    }
    
    class func studentsWithArray(array: NSArray) -> [Student] {
        var students = [Student]()
        
        for pfobj in array {
            students.append(Student(obj: pfobj as PFObject))
        }
        students.sort({$0.firstName < $1.firstName})
        return students
    }
}

