//
//  SpiderViewController.swift
//  kipp-ios
//
//  Created by vli on 11/6/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class SpiderViewController: UIViewController {
    var studentId: Int!
    var loadedTraitValues: [Int]!
    
    var scoresLoaded: Bool = false
    var spiderView: BTSpiderPlotterView!

    let characterTraits = CharacterTrait.defaultCharacterTraitArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var dict = NSMutableDictionary()
        for index in 0..<characterTraits.count {
            dict.setValue("0", forKey: characterTraits[index].title)
        }

        spiderView = BTSpiderPlotterView(frame: self.view.frame, valueDictionary: dict)
        spiderView.maxValue = 1.0
        spiderView.valueDivider = 0.1
        spiderView.drawboardColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        spiderView.plotColor = UIColor(red: CGFloat(96.0/255.0), green: CGFloat(162.0/255.0), blue: CGFloat(215.0/255.0), alpha: CGFloat(0.5))
        self.view.addSubview(spiderView)
        
        loadedTraitValues = [Int](count: characterTraits.count, repeatedValue: 0)
        loadScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadScores() {
        let characterTraits = CharacterTrait.defaultCharacterTraitArray()
        for index in 0..<characterTraits.count {
            let curCharacterTrait = characterTraits[index]
            
            ParseClient.sharedInstance.getLatestCharacterScoreWithCompletion(studentId, characterTrait: curCharacterTrait.title, numDays: nil) { (characterTrait, error) -> () in
                if characterTrait != nil {
                    NSLog("Found \(characterTrait!.title) with score \(characterTrait!.score)")
                    self.loadedTraitValues[index] = characterTrait!.score
                } else {
                    self.loadedTraitValues[index] = 0
                }
                if index == characterTraits.count-1 {
                    self.scoresLoaded = true
                    self.drawGraph()
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
        
        spiderView.animateWithDuration(0.5, valueDictionary: dict)
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
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
