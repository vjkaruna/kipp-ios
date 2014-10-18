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
}
