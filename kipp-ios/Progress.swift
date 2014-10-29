//
//  Progress.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/25/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//


import Foundation

class Progress: NSObject {
    var studentId: Int!

    var week: Int!
    var weeklyProgress: Float!
    var minutes: Int!
    var topic: String!
    
    
    
    init(obj: PFObject) {

        self.minutes = obj["minutes"] as NSInteger
        self.week = obj["week"] as NSInteger
        self.weeklyProgress = obj["weeklyProgress"] as Float
        self.topic = obj["topic"] as NSString
    }

    
    class func progressWithArray(array: NSArray) -> [Progress] {
        var progarray = [Progress]()
        
        for pfobj in array {
            progarray.append(Progress(obj: pfobj as PFObject))
        }
        progarray.sort({$0.week < $1.week})
        return progarray
    }
}
