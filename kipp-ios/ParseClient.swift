//
//  ParseClient.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ParseClient: NSObject {
    override init() {
        super.init()
        Parse.setApplicationId("kyHMOOZDxjNGJ6moZEoRz8WIygUT402Cr4nFgSzA", clientKey: "t32qn2VTGTm5EBCXqo85COvSj945wB5CAqi4KNje")
    }
    
    class var sharedInstance: ParseClient {
        struct Static {
            static let instance = ParseClient()
        }
        return Static.instance
    }
    
    func getCurrentUser() -> PFUser? {
        return PFUser.currentUser()
    }
    
    func loginWithCompletion(username: String, password: String, completion: (user: PFUser?, error: NSError?) -> ()) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            completion(user: user, error: error)
        }
    }
    
    func findClassroomsWithCompletion(completion: (classrooms: [Classroom]?, error: NSError?) -> ()) {
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher", equalTo: PFUser.currentUser())
        classroomQuery.includeKey("students")
        
        classroomQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                let PFClassrooms = objects as [PFObject]
                let classrooms = Classroom.classroomsWithArray(PFClassrooms)
                completion(classrooms: classrooms, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(classrooms: nil, error: error)
            }
        })
    }
    
    func saveCharacterValue(studentId: Int, characterTrait: String, value: Int) {
        // this would save eventually to Parse and store it internally to the student model
        
    }
    
    func markAttendance(studentId: Int, attendance: AttendanceType, forDate: NSDate) {
        var absentEntry = PFObject(className: "Attendance")
        
        absentEntry["type"] = attendance.toRaw()
        absentEntry["date"] = forDate.beginningOfDay()
        absentEntry["studentId"] = studentId
        absentEntry.saveInBackground() // or save eventually?
    }
    
    func getAttendanceForDateWithCompletion(studentId: Int, forDate: NSDate, completion: (attendanceType: AttendanceType?, error: NSError?) -> ()) {
        var attendanceType = AttendanceType.Present
        
        var isAbsentQ = PFQuery(className: "Attendance")
        isAbsentQ.whereKey("studentId", equalTo: studentId)
        isAbsentQ.whereKey("date", equalTo: forDate.beginningOfDay())
        isAbsentQ.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil {
                if results.count > 0 {
                    let result = results[0] as PFObject
                    let rawAttendanceType = result["type"] as Int
                    attendanceType = AttendanceType.fromRaw(rawAttendanceType)!
                    
                    NSLog("Found entry for student \(studentId)")
                } else {
                    NSLog("\(studentId) present")
                }
                completion(attendanceType: attendanceType, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(attendanceType: nil, error: error)
            }
        })
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

