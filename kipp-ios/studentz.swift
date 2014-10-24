//
//  studentz.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//


enum Status {
    case Tardy
    case Late
    case Present
}

class Studentz {
    let name: String
    init(name: String) {
        self.name = name;
    }
    
    func mark(status: Status) {
        println(status)
    }
    
    class func students () -> [Studentz] {
        return ["Robert Collins", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim", "Jennifer Douglas", "Juan Ramirez", "Stephanie Lee", "Don Albertson", "Jered Kim"].map({
            (name: String) -> (Studentz) in Studentz(name: name)
        })
    }
}