//
//  Action.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit


enum ActionType: String {
    case Celebrate = "Celebrate"
    case Encourage = "Needs Work"
    case Call = "Call"
    case History = "History"
    
    func getIconName() -> String {
        switch self {
        case .Celebrate:
            return "celebrate"
        case .Encourage:
            return "needs-work-white"
        case .Call:
            return "call"
        case .History:
            return "history"
        }
    }
}

class Action: NSObject {
    var type: ActionType!
    var reason: String!
    var forDate: NSDate!
    var dateCompleted: NSDate?
    var student: Student!
    var pfobj: PFObject?
    
    init(type: ActionType, reason: String, forDate: NSDate, student: Student) {
        self.type = type
        self.reason = reason
        self.forDate = forDate
        self.student = student
    }
    
    init(pfobj: PFObject) {
        let studentObj = pfobj["student"] as PFObject
        self.type = ActionType(rawValue: pfobj["type"] as String)
        self.reason = pfobj["reason"] as String
        self.forDate = pfobj["dateForAction"] as NSDate
        self.dateCompleted = pfobj["dateCompleted"] as? NSDate
        self.student = Student(obj: studentObj)
        self.pfobj = pfobj
    }
    
    class func actionsWithArray(objs: [PFObject]) -> [Action] {
        var actions = [Action]()
        
        for pfobj in objs {
            actions.append(Action(pfobj: pfobj))
        }
//        actions.sort({$0.forDate > $1.forDate})
        return actions
    }
    
    func setComplete() {
        self.dateCompleted = NSDate().beginningOfDay()
    }
    
    func snoozeForLater(laterDate: NSDate = 1.daysFromNow) {
        self.forDate = laterDate
    }
}