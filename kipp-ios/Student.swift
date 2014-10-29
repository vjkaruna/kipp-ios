//
//  Student.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

enum AttendanceType: Int {
    case Absent = 1, Tardy, Present
}

enum Gender: String {
    case Male = "M"
    case Female = "F"
    
    func profileImg() -> String {
        switch self {
        case .Male:
            return "boy"
        case .Female:
            return "girl"
        default:
            return ""
        }
    }
}

class Student: NSObject {
    var firstName, lastName: String!
    var studentId: Int!
    var gender: Gender!
    var pfObj: PFObject!
    var delegate: StudentProfileChangedDelegate?
    
    var attendance: AttendanceType?
    
    var characterArray: [CharacterTrait] = CharacterTrait.defaultCharacterTraitArray()
    
    init(obj: PFObject) {
        self.firstName = obj["firstName"] as NSString
        self.lastName = obj["lastName"] as NSString
        self.studentId = obj["studentId"] as NSInteger
        let genderChar = obj["gender"] as NSString
        self.gender = Gender(rawValue:genderChar)
        self.pfObj = obj
    }
    
     var fullName: String {
        return "\(self.firstName) \(self.lastName)"
    }
    
    class func studentsWithArray(array: NSArray) -> [Student] {
        var students = [Student]()
        
        for pfobj in array {
            students.append(Student(obj: pfobj as PFObject))
        }
        students.sort({$0.firstName < $1.firstName})
        return students
    }
    
    func markAttendanceForType(type: AttendanceType, forDate: NSDate = NSDate()) {
        ParseClient.sharedInstance.markAttendance(self.studentId, attendance: type, forDate: forDate)
        self.attendance = type
        self.delegate?.attendanceDidChange()
    }
    
    func fillAttendanceState(forDate: NSDate = NSDate()) {
        if attendance == nil {
            ParseClient.sharedInstance.getAttendanceForDateWithCompletion(self.studentId, forDate: forDate, completion: { (attendanceType, error) -> () in
                if attendanceType != nil {
                    self.attendance = attendanceType
                    self.delegate?.attendanceDidChange()
                } else {
                    NSLog("error: \(error)")
                }
            })
        } else {
            NSLog("Attendance state for \(self.firstName) is \(self.attendance!.rawValue)")
        }
    }
}

