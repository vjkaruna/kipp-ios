//
//  Protocols.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import Foundation

protocol ProfileImageTappedDelegate {
    func didTapProfileImg(student: Student)
}

@objc protocol StudentProfileChangedDelegate {
    func attendanceDidChange()
    optional func weeklyProgressDidChange()
}

protocol CharacterTraitUpdatedDelegate {
    func traitScoreDidUpdate(value: Int, forRow row: Int)
}

protocol ReasonSubmittedDelegate {
    func didTapSubmitButton(reasonString: String, actionType: ActionType)
}

protocol ClassroomSelectionDelegrate {
    func didSelectClassroom(classroom: Classroom)
}