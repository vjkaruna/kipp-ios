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
    
    func getIcon() -> String {
        switch self {
        case .Absent:
            return "x2"
        case .Tardy:
            return "alarm2"
        case .Present:
            return "checkmark2"
        }
    }
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
    weak var delegate: StudentProfileChangedDelegate?
    
    var attendance: AttendanceType?
    var weeklyProgress: [Progress]?
    var profileImage: UIImage?
    
    var pastWeekTardyCount: Int?
    var pastWeekAbsentCount: Int?
    
    var characterArray: [CharacterTrait] = CharacterTrait.defaultCharacterTraitArray()
    
    init(obj: PFObject) {
        super.init()
        
        self.firstName = obj["firstName"] as NSString
        self.lastName = obj["lastName"] as NSString
        self.studentId = obj["studentId"] as NSInteger
        let genderChar = obj["gender"] as NSString
        self.gender = Gender(rawValue:genderChar)
        self.pfObj = obj
        if (obj["profilePic"] != nil) {
            var ppic = obj["profilePic"] as PFFile
            ppic.getDataInBackgroundWithBlock { (result, error) in
                if (result != nil) {
                  self.profileImage = UIImage(data: result)
                  self.delegate?.profilePicDidChange!()
                }
            }
        } else {
            profileImage = UIImage(named: self.gender.profileImg())
        }
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
        if pastWeekAbsentCount == nil {
            ParseClient.sharedInstance.getAttendanceCountsForRange(self.studentId, startDate: (-7).daysFromNow, endDate: NSDate()) { (counts, error) -> () in
                if error == nil {
                    self.pastWeekAbsentCount = counts![AttendanceType.Absent]
                    self.pastWeekTardyCount = counts![AttendanceType.Tardy]
                    self.delegate?.attendanceCountsDidChange!(self.studentId, absentCount: counts![AttendanceType.Absent]!, tardyCount: counts![AttendanceType.Tardy]!)
                }
            }
        }
    }
    
    func fillWeeklyProgress() {
        if weeklyProgress == nil {
            ParseClient.sharedInstance.getProgressWithCompletion(self.studentId, completion: { (progressArray, error) -> () in
                self.weeklyProgress = progressArray
                self.delegate?.weeklyProgressDidChange!()
                
            })
        } else {
            NSLog("Already filled progress")
//            self.delegate?.weeklyProgressDidChange!()
        }
    }
}

