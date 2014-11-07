//
//  CharacterPlotView.swift
//  kipp-ios
//
//  Created by vli on 11/7/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

let characterTraits = CharacterTrait.defaultCharacterTraitArray()

class CharacterPlotView: BTSpiderPlotterView {
    
    var studentId: Int!
    var loadedTraitValues = [Int](count: characterTraits.count, repeatedValue: 0)
    
    var scoresLoaded: Bool = false {
        didSet {
            if scoresLoaded && waitingForScores {
                NSLog("Scores loaded.. plotting graph")
                drawGraph() // if we want to load the view with scores, but haven't retrieved them yet, wait for scores to load with property observer
            }
        }
    }
    var waitingForScores: Bool = false
    
    init!(frame: CGRect, valueDictionary: [NSObject : AnyObject]!, studentId: Int) {
        super.init(frame: frame, valueDictionary: valueDictionary)
        
        self.studentId = studentId
        
        self.maxValue = 1.0
        self.valueDivider = 0.1
        self.drawboardColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        self.plotColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        
        loadScores()
    }
    
    convenience init(frame: CGRect, studentId: Int) {
        var dict = NSMutableDictionary()
        for index in 0..<characterTraits.count {
            dict.setValue("0", forKey: characterTraits[index].title)
        }
        self.init(frame: frame, valueDictionary: dict, studentId: studentId)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func plotGraph() {
        if !scoresLoaded {
            waitingForScores = true
            NSLog("Waiting for scores to load...")
        } else {
            drawGraph()
        }
    }
    
    func loadScores() {
        if !scoresLoaded {
            let characterTraits = CharacterTrait.defaultCharacterTraitArray()
            for index in 0..<characterTraits.count {
                let curCharacterTrait = characterTraits[index]
                
                ParseClient.sharedInstance.getLatestCharacterScoreForWeekWithCompletion(studentId, characterTrait: curCharacterTrait.title) { (characterTrait, error) -> () in
                    if characterTrait != nil {
                        NSLog("Found \(characterTrait!.title) with score \(characterTrait!.score)")
                        self.loadedTraitValues[index] = characterTrait!.score
                    } else {
                        self.loadedTraitValues[index] = 0
                    }
                    if index == characterTraits.count-1 {
                        self.scoresLoaded = true
                    }
                }
            }
        }
    }
    
    func drawGraph() {
        var values = getNormalizedValues()
        
        var dict: NSMutableDictionary = NSMutableDictionary()
        for index in 0..<characterTraits.count {
            dict.setValue(values[index], forKey: characterTraits[index].title)
        }
        NSLog("\(dict)")
        
        self.animateWithDuration(0.5, valueDictionary: dict)
    }
    
    func getNormalizedValues() -> [Float] {
        let minVal = minElement(loadedTraitValues) - 1
        let maxVal = maxElement(loadedTraitValues) + 1
        let range = maxVal - minVal
        let zeroVal = -minVal
        NSLog("min: \(minVal), max: \(maxVal), range: \(range), zero: \(zeroVal)")
        var normVals: [Float] = [Float]()
        for score in loadedTraitValues {
            let normScore = score + zeroVal
            normVals.append(Float(normScore)/Float(range))
        }
        return normVals
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
