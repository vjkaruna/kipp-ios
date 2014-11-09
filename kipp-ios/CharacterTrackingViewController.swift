//
//  CharacterTrackingViewController.swift
//  kipp-ios
//
//  Created by vli on 10/21/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CharacterTrackingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CharacterTraitUpdatedDelegate {
    weak var student: Student?
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CharacterTrackerDelegate?
    
    var loadedTraitValues: [Int]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        loadedTraitValues = [Int](count: student!.characterArray.count, repeatedValue: 0)
        loadScores()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return student!.characterArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("characterCell") as CharacterTableViewCell
        let trait = student!.characterArray[indexPath.row]
        cell.characterTrait = trait
        cell.row = indexPath.row
        cell.score = trait.score
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: CGRectMake(0, 0, tableView.frame.width, 35))
    }
    
    func traitScoreDidUpdate(value: Int, forRow row: Int) {
        student!.characterArray[row].score = value
    }
    
    func saveToParse() {
        // Save to Parse
        var scoresToSave = [PFObject]()
        
        var charArray = student!.characterArray
        
        charArray.sort({$0.score < $1.score})
        let weakestTrait = charArray.first
        let strongestTrait = charArray.last
        
        var weakestChanged = false
        var strongestChanged = false
        
        for index in 0..<student!.characterArray.count {
            let characterTrait = student!.characterArray[index]
            if characterTrait.score != loadedTraitValues[index] {
                NSLog("Saving \(characterTrait.title) with value \(characterTrait.score) (Old value: \(loadedTraitValues[index]))")
                var characterEntry = PFObject(className: "CharacterTrait")
                
                characterEntry["type"] = characterTrait.title
                characterEntry["studentId"] = student!.studentId
                characterEntry["score"] = characterTrait.score
                scoresToSave.append(characterEntry)
                if characterTrait.title == weakestTrait!.title {
                    weakestChanged = true
                } else if characterTrait.title == strongestTrait!.title {
                    strongestChanged = true
                }
            }
        }
        if scoresToSave.count > 0 {
            NSLog("Saving scores to parse: \(scoresToSave)")
            ParseClient.sharedInstance.saveArrayInBulk(scoresToSave)
        }
        delegate?.didSaveCharacterTraits(student!.studentId, newStrength: strongestChanged ? strongestTrait : nil, newWeakness: weakestChanged ? weakestTrait : nil)
    }
    
    @IBAction func didTapSave(sender: UIBarButtonItem) {
        saveToParse()
    }
    
    @IBAction func didTapCancel(sender: UIBarButtonItem) {
        delegate?.didSaveCharacterTraits(student!.studentId, newStrength: nil, newWeakness: nil)
    }
    
    func loadScores() {
        for index in 0..<student!.characterArray.count {
            let curCharacterTrait = student!.characterArray[index]
            
            ParseClient.sharedInstance.getLatestCharacterScoreWithCompletion(student!.studentId, characterTrait: curCharacterTrait.title, numDays: -7) { (characterTrait, error) -> () in
                if characterTrait != nil {
                    NSLog("Found \(characterTrait!.title) with score \(characterTrait!.score)")
                    self.student!.characterArray[index].score = characterTrait!.score
                    self.loadedTraitValues[index] = characterTrait!.score
                } else {
                    self.loadedTraitValues[index] = 0
                }
                if index == self.student!.characterArray.count - 1 {
                    self.tableView.reloadData() // this is terrible, but don't know how to do a bulk query on this type of data...
                }
            }
        }
    }
}
