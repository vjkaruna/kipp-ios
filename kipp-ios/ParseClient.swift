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
    
    func logout() {
        PFUser.logOut()
    }
    
    func uploadImage(imageData: NSData, student: PFObject, completion: (profilePic: UIImage?, error:NSError?) -> ()) {
        var pfile = PFFile(name: "Image.jpg", data: imageData)
        student["profilePic"] = pfile
        
        
        student.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if (error == nil) {
                var profilePic = UIImage(data: pfile.getData())
                completion(profilePic: profilePic, error: error)
                // VJ can you double check this works below? 
//                ppic.getDataInBackgroundWithBlock { (result, error) in
//                    let profilePic = UIImage(data: result)
//                    completion(profilePic: profilePic, error: error)
//                }
            } else {
                NSLog("Error: \(error)")
                completion(profilePic: nil, error: error)
            }
        }
    }
    
    func findClassroomsWithCompletion(completion: (classrooms: [Classroom]?, error: NSError?) -> ()) {
        var classroomQuery = PFQuery(className: "Classroom")
        classroomQuery.whereKey("teacher2", equalTo: PFUser.currentUser())
        classroomQuery.includeKey("students")
        classroomQuery.orderByAscending("period")
        
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
    
    func findIncompleteActionsWithCompletion(actionType: ActionType?, classroom: Classroom!, completion: (actions: [Action]?, error: NSError?) -> ()) {
        NSLog("finding incomplete actions with completion")
        var actionQuery = PFQuery(className: "Action")
        if actionType != nil {
            actionQuery.whereKey("type", equalTo: actionType!.rawValue)
        }
        let userId = PFUser.currentUser().objectForKey("userId") as Int

        actionQuery.whereKey("userId", equalTo: userId)
        actionQuery.whereKey("classroom", equalTo: classroom.pfobj)
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
    
    func findCompleteActionsWithCompletion(actionType: ActionType?, classroom: Classroom!, completion: (actions: [Action]?, error: NSError?) -> ()) {
        var actionQuery = PFQuery(className: "Action")
        if actionType != nil {
            actionQuery.whereKey("type", equalTo: actionType!.rawValue)
        }
        let userId = PFUser.currentUser().objectForKey("userId") as Int

        actionQuery.whereKey("userId", equalTo: userId)
        actionQuery.whereKey("classroom", equalTo: classroom.pfobj)
        actionQuery.whereKeyExists("dateComplete")
        actionQuery.orderByDescending("dateComplete")
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
    
    func getLatestCharacterScoreWithCompletion(studentId: Int, characterTrait: String, numDays: Int?, completion: (characterTrait: CharacterTrait?, error: NSError?) -> ()) {
        var characterQuery = PFQuery(className: "CharacterTrait")
        characterQuery.whereKey("type", equalTo: characterTrait)
        characterQuery.whereKey("studentId", equalTo: studentId)
        if numDays != nil {
            characterQuery.whereKey("createdAt", greaterThanOrEqualTo: numDays!.daysFromNow)    // Score for the past week
        }
        characterQuery.orderByDescending("createdAt")
        characterQuery.getFirstObjectInBackgroundWithBlock({ (pfobject, error) -> Void in
            if pfobject != nil {
                let characterTrait = CharacterTrait(pfobj: pfobject)
                completion(characterTrait: characterTrait, error: nil)
            } else {
                completion(characterTrait: nil, error: error)
            }
        })
    }
    
    // TODO: these only pull the max/min values, but not necessarily the most recent ones
    func getGreatestScoreForWeekWithCompletion(studentId: Int, completion: (characterTrait: CharacterTrait?, error: NSError?) -> ()) {
        var characterQuery = PFQuery(className: "CharacterTrait")
        characterQuery.whereKey("studentId", equalTo: studentId)
        characterQuery.whereKey("createdAt", greaterThanOrEqualTo: (-7).daysFromNow)    // Score for the past week
        characterQuery.orderByDescending("score")
        characterQuery.getFirstObjectInBackgroundWithBlock({ (pfobject, error) -> Void in
            if pfobject != nil {
                let characterTrait = CharacterTrait(pfobj: pfobject)
                completion(characterTrait: characterTrait, error: nil)
            } else {
                completion(characterTrait: nil, error: error)
            }
        })
    }
    
    func getWeakestScoreForWeekWithCompletion(studentId: Int, completion: (characterTrait: CharacterTrait?, error: NSError?) -> ()) {
        var characterQuery = PFQuery(className: "CharacterTrait")
        characterQuery.whereKey("studentId", equalTo: studentId)
        characterQuery.whereKey("createdAt", greaterThanOrEqualTo: (-7).daysFromNow)    // Score for the past week
        characterQuery.orderByAscending("score")
        characterQuery.getFirstObjectInBackgroundWithBlock({ (pfobject, error) -> Void in
            if pfobject != nil {
                let characterTrait = CharacterTrait(pfobj: pfobject)
                completion(characterTrait: characterTrait, error: nil)
            } else {
                completion(characterTrait: nil, error: error)
            }
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
        isAbsentQ.orderByDescending("createdAt")
        isAbsentQ.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil {
                if results.count > 0 {
                    let result = results[0] as PFObject
                    let rawAttendanceType = result["type"] as Int
                    attendanceType = AttendanceType(rawValue: rawAttendanceType)!
                    
                    NSLog("Found \(rawAttendanceType) entry for student \(studentId)")
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
    func getAttendanceCountsForRange(studentId: Int, startDate: NSDate, endDate: NSDate, completion: (counts: [AttendanceType: Int]?, error: NSError?) -> ()) {
        var countQ = PFQuery(className: "Attendance")
        countQ.whereKey("studentId", equalTo: studentId)
        countQ.whereKey("date", greaterThanOrEqualTo: startDate.beginningOfDay())
        countQ.whereKey("date", lessThanOrEqualTo: endDate.beginningOfDay())
        countQ.findObjectsInBackgroundWithBlock({ (results, error) -> Void in
            if error == nil {
                var absentCount = 0
                var tardyCount = 0
                var datesSeen = [NSDate]()
                for result in results as [PFObject] {
                    let rawAttendanceType = result["type"] as Int
                    let attendanceType = AttendanceType(rawValue: rawAttendanceType)!
                    if attendanceType == AttendanceType.Absent {
                        absentCount += 1
                    } else if attendanceType == AttendanceType.Tardy {
                        tardyCount += 1
                    }
                }
                completion(counts: [AttendanceType.Tardy: tardyCount, AttendanceType.Absent: absentCount], error: nil)
            } else {
                completion(counts: nil, error: error)
            }
        })
    }
    
    func getProgressWithCompletion(studentId: Int, completion: (progressArray: [Progress], error: NSError?) -> ()) {
        var parentQuery = PFQuery(className: "Progress")
        parentQuery.whereKey("studentId", equalTo: studentId)
        
        parentQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                let PFProgress = objects as [PFObject]
                let progressArray = Progress.progressWithArray(PFProgress)
                completion(progressArray: progressArray, error: nil)
            } else {
                NSLog("error: \(error)")
                completion(progressArray: [Progress](), error: error)
            }
        }
        
    }

    func saveActionObjectWithCompletion(studentObj: PFObject, action: Action, classroom: Classroom, completion: (parseObj: PFObject?, error: NSError?) -> ()) {
        var actionEntry = PFObject(className: "Action")
        
        actionEntry["type"] = action.type.rawValue
        actionEntry["reason"] = action.reason
        actionEntry["dateForAction"] = action.forDate
        if action.dateCompleted != nil {
            actionEntry["dateCompleted"] = action.dateCompleted
        }
        actionEntry["student"] = studentObj
        actionEntry["classroom"] = classroom.pfobj
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
let secondsInMin: NSTimeInterval = 60
let minInHours: NSTimeInterval = 60
let hoursInDay: NSTimeInterval = 24

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
    func toPrettyString(simple: Bool = true) -> String {
        if simple {
            let pastInSeconds = -(self.timeIntervalSinceNow)
            
            if pastInSeconds < secondsInMin {
                return "\(Int(pastInSeconds))s ago"
            } else if pastInSeconds < secondsInMin * minInHours {
                let minutes = Int(pastInSeconds / secondsInMin)
                return "\(minutes)m ago"
            } else if pastInSeconds < secondsInMin * minInHours * hoursInDay {
                let hours = Int(pastInSeconds / (secondsInMin * minInHours))
                return "\(hours)h ago"
            } else {
                let formatter = NSDateFormatter()
                formatter.dateFormat = "MMM dd"
                return formatter.stringFromDate(self)
            }
        } else {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "MMM dd, YYYY - h:mm a"
            return formatter.stringFromDate(self)
        }
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

