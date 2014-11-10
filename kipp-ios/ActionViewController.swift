//
//  ActionViewController.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate, ProfileImageTappedDelegate {
// TODO: Need to pull out current class context into User model so we can query students
// Should this be an agenda view instead??
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var actionType: ActionType?
    
    var data: [Action]?
    
    var selectedRow: Int?
    
    var emptyView: EmptyDataView!
    
//    var labelHeights: [CGFloat]?
    
    weak var currentClass: Classroom?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = actionType?.rawValue
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "studentCell")
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)

        loadCurrentClass() {
            if self.actionType! != ActionType.History {
                ParseClient.sharedInstance.findIncompleteActionsWithCompletion(self.actionType!, classroom: self.currentClass) { (actions, error) -> () in
                    NSLog("Completion called for action type \(self.actionType!.rawValue)")
                    if actions != nil {
                        self.data = actions
//                        self.labelHeights = [CGFloat](count: actions!.count, repeatedValue: CGFloat(0.0))
                        self.tableView.reloadData()
                        self.loadDataOrEmptyState()
                    } else {
                        NSLog("Error getting actions: \(error)")
                    }
                }
            } else {
                ParseClient.sharedInstance.findCompleteActionsWithCompletion(nil, classroom: self.currentClass, completion: { (actions, error) -> () in
                    if actions != nil {
                        self.data = actions
//                        self.labelHeights = [CGFloat](count: actions!.count, repeatedValue: CGFloat(0.0))
                        self.tableView.reloadData()
                        self.loadDataOrEmptyState()
                    } else {
                        NSLog("Error getting actions: \(error)")
                    }
                })
            }
        }
    }

    func loadCurrentClass(completion: (() -> ())) {
        if currentClass == nil {
            Classroom.currentClassWithCompletion() {
                (classroom: Classroom?, error: NSError?) -> () in
                self.currentClass = classroom
                completion()
            }
        } else {
            completion()
        }
    }
    
    @IBAction func didChangeControl(sender: UISegmentedControl) {
//        reloadTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data != nil {
            return data!.count
        } else {
            return 0
        }
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        if selectedRow == nil || selectedRow! != indexPath.row {
//            selectedRow = indexPath.row
//        } else if selectedRow! == indexPath.row {
//            selectedRow = nil
//            NSLog("Collapse row \(indexPath.row)")
//        }
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//
//        tableView.beginUpdates()
//        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
//        tableView.endUpdates()
//    }
    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if selectedRow == nil || selectedRow != indexPath.row {
//            return 68
//        } else {
//            if labelHeights![indexPath.row] == CGFloat(0.0) {
//                return 68
//            } else {
//                return labelHeights![indexPath.row] + 68.0 + 20.0
//            }
//        }
//    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let action = data![indexPath.row]
        cell.metadataLabel.text = action.reason
        cell.student = action.student
        if action.dateCompleted != nil {
            NSLog("date completed: \(action.dateCompleted); prettyString: \(action.dateCompleted!.toPrettyString())")
            cell.dateCompleteLabel.text = ("\(action.type.getPastTenseName()) \(action.dateCompleted!.toPrettyString())")
        }
        if actionType! != .History {
            cell.delegate = self
            cell.rightButtons = createRightButton()
            cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
            cell.rightExpansion.buttonIndex = 0
            cell.rightExpansion.fillOnTrigger = true
        }

//        cell.layoutIfNeeded()
//        labelHeights![indexPath.row] = cell.actionComments.bounds.size.height
//        cell.clipsToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func loadDataOrEmptyState() {
        if data!.count > 0 {
            tableView.hidden = false
            emptyView.hidden = true
        } else {
            emptyView.hidden = false
            tableView.hidden = true
            if actionType! == ActionType.History {
                emptyView.actionType = actionType
                emptyView.type = .CompletedAction
            } else {
                emptyView.actionType = actionType
                emptyView.type = .ActionToTake
            }
        }
    }
    
    func createRightButton() -> NSArray {
        var button = MGSwipeButton(title: "Done", backgroundColor: UIColor.greenTint()) { (cell) -> Bool in
            NSLog("Tapped Done for \(cell)")
            self.markActionComplete(cell)
            return true
        }
        return [button]
    }

    func markActionComplete(cell: UITableViewCell) {
        let indexPath = self.tableView.indexPathForCell(cell)!
        let action = data![indexPath.row]
        ParseClient.sharedInstance.markActionAsComplete(action) { (success, error) -> () in
            NSLog("Updated object in Parse")
        }
        
        NSLog("Removing cell at \(indexPath.row)")
        data!.removeAtIndex(indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
        
        loadDataOrEmptyState()
    }
    
    func didTapProfileImg(student: Student) {
        NSLog("Tapped profile")
        let parentSB = UIStoryboard(name: "ParentCalls", bundle: nil)
        let profileVC = parentSB.instantiateViewControllerWithIdentifier("studentProfileC") as ProfileGraphViewController
        
        profileVC.student = student
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
}
