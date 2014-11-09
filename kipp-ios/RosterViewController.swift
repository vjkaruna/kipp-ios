//
//  RosterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class RosterViewController: BaseClassroomViewController, UITableViewDelegate, UITableViewDataSource, ProfileImageTappedDelegate, MGSwipeTableCellDelegate, CharacterTrackerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var teacher: PFUser!
    var weakTraits = [Int: CharacterTrait]()
    var strongTraits = [Int: CharacterTrait]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadClassroom()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "studentCell")
        
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if classroomReloadNeeded {
            _loadClassroom()
        } else {
            tableView.reloadData()
        }
    }
    
//    func loadClassroom() {
//        var classroom = Classroom.currentClass()
//        if classroom == nil {
//            Classroom.currentClassWithCompletion() { (classroom: Classroom?, error: NSError?) -> Void in
//                if classroom != nil {
//                    self.classroom = classroom
//                    self.tableView.reloadData()
//                    self.navigationItem.title = "Period \(classroom!.period): Character"
//                    NSLog(classroom?.title ?? "nil")
//                }
//                else {
//                    NSLog("error getting classroom data from Parse")
//                }
//            }
//        } else {
//            self.classroom = classroom
//            self.tableView.reloadData()
//            self.navigationItem.title = "Period \(classroom!.period): Character"
//        }
//    }
    
    override func classroomLoaded() {
        super.classroomLoaded()
        self.navigationItem.title = "Period \(classroom!.period): Character"
        loadStudentData()
    }
    
    func loadStudentData() {
        for student in classroom.students {
            ParseClient.sharedInstance.getGreatestScoreForWeekWithCompletion(student.studentId) { (characterTrait, error) -> () in
                if characterTrait != nil {
                    NSLog("\(characterTrait!.title) with score \(characterTrait!.score)")
                    self.strongTraits[student.studentId] = characterTrait!
                } else {
                    NSLog("No strong character trait for student \(student.studentId)")
                    self.strongTraits[student.studentId] = nil
                }
//                if self.weakTraits.count == self.classroom.students.count && self.strongTraits.count == self.classroom.students.count {
                self.studentDataLoaded()
//                }
            }
            ParseClient.sharedInstance.getWeakestScoreForWeekWithCompletion(student.studentId) { (characterTrait, error) -> () in
                if characterTrait != nil {
                    NSLog("\(characterTrait!.title) with score \(characterTrait!.score)")
                    self.weakTraits[student.studentId] = characterTrait!
                } else {
                    NSLog("No weak character trait for student \(student.studentId): \(self.weakTraits.count)")
                    self.weakTraits[student.studentId] = nil
                }
//                if self.weakTraits.count == self.classroom.students.count && self.strongTraits.count == self.classroom.students.count {
                self.studentDataLoaded()
//                }
            }
        }
    }
    
    func studentDataLoaded() {
        if (self.tableView != nil) {
          self.tableView.reloadData()
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return classroom?.students?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let student = classroom.students[indexPath.row]
        cell.student = student
        cell.profileDelegate = self
        cell.delegate = self
        cell.rightButtons = createRightButtons()
        
        let weaknessAttributes = [NSForegroundColorAttributeName: UIColor.myRedColor()]
        let strengthAttributes = [NSForegroundColorAttributeName: UIColor.greenTint()]
        let neutralAttributes = [NSForegroundColorAttributeName: UIColor.grayColor()]
        let charText = NSMutableAttributedString()
        
        let strongTrait = strongTraits[student.studentId]
        let weakTrait = weakTraits[student.studentId]
        
        if strongTrait != nil {
            if weakTrait != nil {
                if weakTrait!.title != strongTrait!.title {
                    charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
                    charText.appendAttributedString(NSAttributedString(string: "\n\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
                } else {
                    if weakTrait!.score < 0 {
                        charText.appendAttributedString(NSAttributedString(string: "\n\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
                    } else if weakTrait!.score > 0 {
                        charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
                    }
                }
            } else {
                charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
            }
        }
        if charText.length == 0 && weakTrait != nil {
            charText.appendAttributedString(NSAttributedString(string: "\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
        }
        if charText.length == 0 {
            charText.appendAttributedString(NSAttributedString(string: "No scores recorded this week", attributes: neutralAttributes))
        }
        
        cell.metadataLabel.attributedText = charText
        //        cell.leftButtons = []
        //        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionDrag
        cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.rightExpansion.fillOnTrigger = false

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let student = classroom.students[indexPath.row]
        self.performSegueWithIdentifier("characterSegue", sender: student)
    }

    func createRightButtons() -> NSArray {
        var button = MGSwipeButton(title: "Actions", backgroundColor: UIColor.darkBlue()) { (cell) -> Bool in
            NSLog("Tapped actions for \(cell)")
//            self.markActionComplete(self.tableView.indexPathForCell(cell)!)
            return true
        }
        return [button]
    }
    
    
    func didTapProfileImg(student: Student) {
//        self.performSegueWithIdentifier("profileSegue", sender: student)
        let parentSB = UIStoryboard(name: "ParentCalls", bundle: nil)
        let profileVC = parentSB.instantiateViewControllerWithIdentifier("studentProfileC") as ProfileGraphViewController
        
        profileVC.student = student
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "profileSegue") {
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.student = sender as? Student
        } else if (segue.identifier == "characterSegue") {
            var characterVC = segue.destinationViewController as CharacterTrackingViewController
            characterVC.student = sender as? Student
            characterVC.delegate = self
        }
    }
    
    func getScoreMetadataText(studentId: Int) -> NSAttributedString {
        let weaknessAttributes = [NSForegroundColorAttributeName: UIColor.myRedColor()]
        let strengthAttributes = [NSForegroundColorAttributeName: UIColor.greenTint()]
        let neutralAttributes = [NSForegroundColorAttributeName: UIColor.grayColor()]
        let charText = NSMutableAttributedString()
        
        let strongTrait = strongTraits[studentId]
        let weakTrait = weakTraits[studentId]
        
        if strongTrait != nil {
            if weakTrait != nil  {
                if weakTrait!.title != strongTrait!.title && weakTrait!.score <= 0 {
                    charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
                    charText.appendAttributedString(NSAttributedString(string: "\n\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
                } else {
                    if weakTrait!.score < 0 {
                        charText.appendAttributedString(NSAttributedString(string: "\n\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
                    } else if weakTrait!.score > 0 {
                        charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
                    }
                }
            } else {
                charText.appendAttributedString(NSAttributedString(string: "\(strongTrait!.title): \(strongTrait!.score)", attributes: strengthAttributes))
            }
        }
        if charText.length == 0 && weakTrait != nil && weakTrait!.score <= 0 {
            charText.appendAttributedString(NSAttributedString(string: "\(weakTrait!.title): \(weakTrait!.score)", attributes: weaknessAttributes))
        }
        if charText.length == 0 {
            charText.appendAttributedString(NSAttributedString(string: "No scores recorded this week", attributes: neutralAttributes))
        }
        return charText
    }
    
    func didSaveCharacterTraits(studentId: Int, newStrength: CharacterTrait?, newWeakness: CharacterTrait?) {
        classroomReloadNeeded = false
        if newStrength != nil {
            NSLog("updating \(newStrength!.title) trait for student \(studentId)")
            strongTraits[studentId] = newStrength
        }
        if newWeakness != nil {
            NSLog("updating \(newWeakness!.title) trait for student \(studentId)")
            weakTraits[studentId] = newWeakness
        }
//        tableView.reloadData()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
