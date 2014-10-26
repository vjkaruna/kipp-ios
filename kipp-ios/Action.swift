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
    case Encourage = "Encourage"
    case Call = "Call"
}

class Action: NSObject {
    var type: ActionType!
    var reason: String!
    var forDate: NSDate!
    var dateCompleted: NSDate?
    // unowned student: Student! ???
    
    init(type: ActionType, reason: String, forDate: NSDate) {
        self.type = type
        self.reason = reason
        self.forDate = forDate
    }
    
    init(pfobj: PFObject) {
        self.type = ActionType.fromRaw(pfobj["type"] as String)
        self.reason = pfobj["reason"] as String
        self.forDate = pfobj["dateForAction"] as NSDate
        self.dateCompleted = pfobj["dateCompleted"] as? NSDate
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