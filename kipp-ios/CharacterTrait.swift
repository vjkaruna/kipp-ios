//
//  CharacterTrait.swift
//  kipp-ios
//
//  Created by vli on 10/18/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit


enum CharacterLabTraits: String {
    case Curiosity = "Curiosity"
    case Gratitude = "Gratitude"
    case Grit = "Grit"
    case Optimism = "Optimism"
    case SelfControl = "Self Control"
    case SocialIntelligence = "Social Intelligence"
    case Zest = "Zest"
    
    func getRoundAsset() -> String {
        switch self {
        case Curiosity:
            return "character-curiosity2"
        case .Gratitude:
            return "character-gratitude2"
        case .Grit:
            return "character-grit2"
        case .Optimism:
            return "character-optimism2"
        case .SelfControl:
            return "character-self-control2"
        case .SocialIntelligence:
            return "character-social-intelligence2"
        case .Zest:
            return "character-zest2"
        }
    }
    
    static let all = [Curiosity, Gratitude, Grit, Optimism, SelfControl, SocialIntelligence, Zest]
}

class CharacterTrait: NSObject {
    var score: Int!
    var title: String!
    var imgName: String!
    var objectId: String?   // This is the Parse object ID so we can simply update value's entry
    
    init(title: String, imgName: String, currentScore: Int = 0) {
        self.title = title
        self.score = currentScore
        self.imgName = imgName
    }
    
    init(pfobj: PFObject) {
        self.title = pfobj["type"] as String
        self.score = pfobj["score"] as Int
        self.imgName = CharacterLabTraits(rawValue: self.title)!.getRoundAsset()
    }
    
    class func defaultCharacterTraitArray() -> [CharacterTrait] {
        var characterArray = [CharacterTrait]()
        for trait in CharacterLabTraits.all {
            characterArray.append(CharacterTrait(title: trait.rawValue, imgName: trait.getRoundAsset()))
        }
        return characterArray
    }
//    
//    func getAsset() -> String {
//        switch self {
//        case Curiosity:
//            return "character-curiosity2"
//        case .Gratitude:
//            return "character-gratitude2"
//        case .Grit:
//            return "character-grit2"
//        case .Optimism:
//            return "character-optimism2"
//        case .SelfControl:
//            return "character-self-control2"
//        case .SocialIntelligence:
//            return "character-social-intelligence2"
//        case .Zest:
//            return "character-zest2"
//        }
//    }
//    func getRoundAsset() -> String {
//        switch self {
//        case Curiosity:
//            return "character-curiosity"
//        case .Gratitude:
//            return "character-gratitude"
//        case .Grit:
//            return "character-grit"
//        case .Optimism:
//            return "character-optimism"
//        case .SelfControl:
//            return "character-self-control"
//        case .SocialIntelligence:
//            return "character-social-intelligence"
//        case .Zest:
//            return "character-zest"
//        }
//    }
//    static func getFromIndex(index: Int) -> CharacterTrait {
//        return CharacterTrait.all[index]
//    }
//    
//    static let all = [Curiosity, Gratitude, Grit, Optimism, SelfControl, SocialIntelligence, Zest]
}