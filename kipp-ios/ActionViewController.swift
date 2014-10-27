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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = actionType?.toRaw()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        var nib = UINib(nibName: "StudentTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "studentCell")
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)
        
        if actionType! != ActionType.History {
            ParseClient.sharedInstance.findIncompleteActionsWithCompletion(actionType!) { (actions, error) -> () in
                NSLog("Completion called for action type \(self.actionType!.toRaw())")
                if actions != nil {
                    self.data = actions
                    self.tableView.reloadData()
                    self.loadDataOrEmptyState()
                } else {
                    NSLog("Error getting actions: \(error)")
                }
            }
        } else {
            ParseClient.sharedInstance.findCompleteActionsWithCompletion(nil) { (actions, error) -> () in
                if actions != nil {
                    self.data = actions
                    self.tableView.reloadData()
                    self.loadDataOrEmptyState()
                } else {
                    NSLog("Error getting actions: \(error)")
                }
            }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if selectedRow == nil || selectedRow! != indexPath.row {
            selectedRow = indexPath.row
            let cell = tableView.cellForRowAtIndexPath(indexPath) as? StudentTableViewCell
            NSLog("Selected row \(indexPath.row); \(cell!.actionReason)")
        } else if selectedRow! == indexPath.row {
            selectedRow = nil
            NSLog("Collapse row \(indexPath.row)")
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        tableView.beginUpdates()
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        tableView.endUpdates()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        let cell = tableView.cellForRowAtIndexPath(indexPath) as? StudentTableViewCell
//        cell?.layoutIfNeeded()
        
        if selectedRow == nil || selectedRow != indexPath.row {
            return 68
        } else {
//            if cell != nil {
//                return 68 + cell!.actionComments.bounds.height + 8
//            } else {
            return 68 * 2
//            }
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("studentCell") as StudentTableViewCell
        let action = data![indexPath.row]
        cell.actionReason = action.reason
        cell.student = action.student
//        NSLog("\(cell)")
        
        if actionType! != .History {
            cell.delegate = self
            cell.rightButtons = createRightButton()
    //        cell.leftButtons = []
    //        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionDrag
            cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
            cell.rightExpansion.buttonIndex = 0
            cell.rightExpansion.fillOnTrigger = true
        }
        cell.clipsToBounds = true
        cell.layoutIfNeeded()
        return cell
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
//        var button = MGSwipeButton(title: "Delete", backgroundColor: UIColor.myRedColor()) { (cell) -> Bool in
//            NSLog("Tapped delete for \(cell)")
//            self.markActionComplete(self.tableView.indexPathForCell(cell)!)
//            return true
//        }
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
    }
}
