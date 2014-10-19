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

protocol StudentProfileChangedDelegate {
    func attendanceDidChange()
}

protocol CharacterTraitUpdatedDelegate {
    func traitScoreDidUpdate(value: Int, forRow row: Int)
}