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
    
    func findParentsWithCompletion(completion: (parents: [Parent]?, error: NSError?) -> ()) {
        var parentQuery = PFQuery(className: "Parent")
        parentQuery.includeKey("Student")
        
        parentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                let PFParents = objects as [PFObject]
                let parents = Parent.parentsWithArray(PFParents)
                completion(parents: parents, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(parents: nil, error: error)
            }
        }
    }
    
    func loginWithCompletion(username: String, password: String, completion: (user: PFUser?, error: NSError?) -> ()) {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            completion(user: user, error: error)
        }
    }
    
    func findClassroomsWithCompletion(completion: (classrooms: [Classroom]?, error: NSError?) -> ()) {
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher2", equalTo: PFUser.currentUser())
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
    
    func findIncompleteActionsWithCompletion(actionType: ActionType?, completion: (actions: [Action]?, error: NSError?) -> ()) {
        var actionQuery = PFQuery(className: "Action")
        if actionType != nil {
            actionQuery.whereKey("type", equalTo: actionType!.rawValue)
        }
        let userId = PFUser.currentUser().objectForKey("userId") as Int

        actionQuery.whereKey("userId", equalTo: userId)
        actionQuery.whereKeyDoesNotExist("dateComplete")
        actionQuery.orderByDescending("dateForAction")
        actionQuery.includeKey("student")

        actionQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            NSLog("Found objects")
            if error == nil {
                let PFActions = objects as [PFObject]
                let actions = Action.actionsWithArray(PFActions)
                NSLog("About to call completion handler")
                completion(actions: actions, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(actions: nil, error: error)
            }
        })
    }
    
    func findCompleteActionsWithCompletion(actionType: ActionType?, completion: (actions: [Action]?, error: NSError?) -> ()) {
        var actionQuery = PFQuery(className: "Action")
        if actionType != nil {
            actionQuery.whereKey("type", equalTo: actionType!.rawValue)
        }
        let userId = PFUser.currentUser().objectForKey("userId") as Int

        actionQuery.whereKey("userId", equalTo: userId)
        actionQuery.whereKeyExists("dateComplete")
        actionQuery.orderByDescending("dateForAction")
        actionQuery.includeKey("student")
        
        actionQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                let PFActions = objects as [PFObject]
                let actions = Action.actionsWithArray(PFActions)
                completion(actions: actions, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(actions: nil, error: error)
            }
        })
    }
    
    func markActionAsComplete(action: Action, completion: (success: Bool, error: NSError?) -> ()) {
        var actionToUpdate = action.pfobj!
        actionToUpdate["dateComplete"] = NSDate()
        
        actionToUpdate.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completion(success: true, error: nil)
            } else {
                completion(success: false, error: error)
            }
        }
    }

    
    func saveCharacterValueWithCompletion(studentId: Int, characterTrait: CharacterTrait, forDate: NSDate, completion: (parseObj: PFObject?, error: NSError?) -> ()) {
        var characterEntry = PFObject(className: "CharacterTrait")
        
        if characterEntry.objectId != nil {
            characterEntry["objectId"] = characterEntry.objectId
        }
        characterEntry["type"] = characterTrait.title
        characterEntry["studentId"] = studentId
        characterEntry["score"] = characterTrait.score

        characterEntry.saveInBackgroundWithBlock { (saved, error) -> Void in
            if saved {
                completion(parseObj: characterEntry, error: nil)
            } else {
                NSLog("Failed to save character trait entry")
                completion(parseObj: nil, error: error)
            }
        }
    }
    
    func getLatestCharacterScoreForWeekWithCompletion(studentId: Int, characterTrait: String, completion: (characterTrait: CharacterTrait?, error: NSError?) -> ()) {
        var characterQuery = PFQuery(className: "CharacterTrait")
        characterQuery.whereKey("type", equalTo: characterTrait)
        characterQuery.whereKey("studentId", equalTo: studentId)
        characterQuery.orderByDescending("createdAt")
        characterQuery.getFirstObjectInBackgroundWithBlock({ (pfobject, error) -> Void in
            if pfobject != nil {
                let characterTrait = CharacterTrait(pfobj: pfobject)
                completion(characterTrait: characterTrait, error: nil)
            } else {
                completion(characterTrait: nil, error: error)
            } // TODO filter by week
        })
    }
    
    func saveArrayInBulk(array: NSArray) {
//        PFObject.saveAllInBackground(array, target: AnyObject!, selector: <#Selector#>)
        PFObject.saveAllInBackground(array)
    }
    
    func markAttendance(studentId: Int, attendance: AttendanceType, forDate: NSDate) {
        var absentEntry = PFObject(className: "Attendance")
        
        absentEntry["type"] = attendance.rawValue
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
                    attendanceType = AttendanceType(rawValue: rawAttendanceType)!
                    
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
    
    func saveActionObjectWithCompletion(studentObj: PFObject, action: Action, completion: (parseObj: PFObject?, error: NSError?) -> ()) {
        var actionEntry = PFObject(className: "Action")
        
        actionEntry["type"] = action.type.rawValue
        actionEntry["reason"] = action.reason
        actionEntry["dateForAction"] = action.forDate
        if action.dateCompleted != nil {
            actionEntry["dateCompleted"] = action.dateCompleted
        }
        actionEntry["student"] = studentObj
        actionEntry["userId"] = PFUser.currentUser().objectForKey("userId") as Int
        
        actionEntry.saveInBackgroundWithBlock { (saved, error) -> Void in
            if saved {
                completion(parseObj: actionEntry, error: nil)
            } else {
                NSLog("Failed to save action entry for student \(studentObj)")
                completion(parseObj: nil, error: error)
            }
        }
    }
}

let calendar = NSCalendar(identifier: NSGregorianCalendar)!

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

extension Int {
    var daysFromNow: NSDate {
        let today = NSDate().beginningOfDay()
        let dateComponents = NSDateComponents()
        dateComponents.day = self
        return calendar.dateByAddingComponents(dateComponents, toDate: today, options: nil)!
    }
}

