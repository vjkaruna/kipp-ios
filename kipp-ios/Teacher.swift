//
//  Teacher.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import Foundation

let userDidLogoutNotification = "userDidLogoutNotification"
let userDidLoginNotification = "userDidLoginNotification"

class Teacher: NSObject {
    var username: String!
    
    init(obj: PFObject) {
        self.username = obj["firstName"] as NSString
    }
}