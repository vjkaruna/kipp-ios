//
//  Parent.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import Foundation

class Parent: NSObject {
    var firstName, lastName, phone: String!
    var studentId: Int!
    var parentId: Int!
    var student: Student?
    var lastCalledDate: NSDate!
    
    
    init(obj: PFObject) {
        self.firstName = obj["firstName"] as NSString
        self.lastName = obj["lastName"] as NSString
        self.studentId = obj["studentId"] as NSInteger
        self.phone = obj["phone"] as NSString
        self.parentId = obj["parentId"] as NSInteger
        let studentobj = obj.objectForKey("Student") as PFObject
        self.student = Student(obj: studentobj)
        self.lastCalledDate = obj.updatedAt
    }
    
    var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    class func parentsWithArray(array: NSArray) -> [Parent] {
        var parents = [Parent]()
        
        for pfobj in array {
            parents.append(Parent(obj: pfobj as PFObject))
        }
        parents.sort({$0.firstName < $1.firstName})
        return parents
    }
}