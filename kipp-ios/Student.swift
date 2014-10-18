//
//  Student.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

//let studentAttendanceStateChanged = "studentAttendanceStateChanged"

enum AttendanceType: Int {
    case Absent = 1, Tardy, Present
}

class Student: NSObject {
    var firstName, lastName: String!
    var studentId: Int!
    
    var delegate: StudentProfileChangedDelegate?
    
    var attendance: AttendanceType? /*{
        willSet {
            if newValue != nil && newValue != .Present {
                // Send notification only for absent or tardy updates
                self.delegate?.attendanceDidChange()
            }
        }
    }*/
    
    init(obj: PFObject) {
        self.firstName = obj["firstName"] as NSString
        self.lastName = obj["lastName"] as NSString
        self.studentId = obj["studentId"] as NSInteger
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
    
    func markAttendanceForType(type: AttendanceType, forDate: NSDate = NSDate.date()) {
        var absentEntry = PFObject(className: "Attendance")
        absentEntry["type"] = type.toRaw()
        absentEntry["date"] = forDate.beginningOfDay()
        absentEntry["studentId"] = self.studentId
        absentEntry.saveInBackground() // or save eventually?
        self.attendance = type
        self.delegate?.attendanceDidChange()
    }
    
    func fillAttendanceState(forDate: NSDate = NSDate.date()) {
        if attendance == nil {
            var isAbsentQ = PFQuery(className: "Attendance")
            isAbsentQ.whereKey("studentId", equalTo: self.studentId)
//            isAbsentQ.whereKey("type", equalTo: AttendanceType.Absent.toRaw())
            isAbsentQ.whereKey("date", equalTo: forDate.beginningOfDay())
            isAbsentQ.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
                if error == nil {
                    if results.count > 0 {
                        let result = results[0] as PFObject
                        let rawAttendanceType = result["type"] as Int
                        self.attendance = AttendanceType.fromRaw(rawAttendanceType)
                        self.delegate?.attendanceDidChange()
                        NSLog("Found entry for student \(self.firstName)")
                    } else {
                        self.attendance = .Present
                        NSLog("\(self.firstName) present")
                    }
                } else {
                    NSLog("error: \(error)")
                }
            })
        } else {
            NSLog("Attendance state for \(self.firstName) is \(self.attendance!.toRaw())")
        }
    }
}

let calendar = NSCalendar(identifier: NSGregorianCalendar)

extension NSDate {
    func isSameDay(date: NSDate) -> Bool {
        let dateComponents = calendar.components( .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: date)
        let nowComponents = calendar.components( .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: NSDate())
        return (dateComponents.day == nowComponents.day && dateComponents.month == nowComponents.month && dateComponents.year == nowComponents.year)
    }
    func beginningOfDay() -> NSDate {
        let dateComponents = calendar.components( .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: self)
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.second = 0
        return calendar.dateFromComponents(dateComponents)!
    }
    func endOfDay() -> NSDate {
        let dateComponents = calendar.components( .DayCalendarUnit | .MonthCalendarUnit | .YearCalendarUnit, fromDate: self)
        dateComponents.hour = 23
        dateComponents.minute = 59
        dateComponents.second = 59
        return calendar.dateFromComponents(dateComponents)!
    }
}

