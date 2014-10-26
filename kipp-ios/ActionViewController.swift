//
//  ActionViewController.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

enum ActionViewMode: Int {
    case Action = 0, Completed
    
}

class ActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// TODO: Need to pull out current class context into User model so we can query students
// Should this be an agenda view instead??
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var actions: [Action]?
    var completed: [Action]?
    var currentData: [Action]?
    
    var emptyView: EmptyDataView!
    
    let views = ["Actions", "Completed"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ActionTableViewCell.self, forCellReuseIdentifier: "actionCell")
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)
        
        ParseClient.sharedInstance.findIncompleteActionsWithCompletion(nil) { (actions, error) -> () in
            NSLog("Completion called")
            if actions != nil {
                
                self.actions = actions
                if self.segmentedControl.selectedSegmentIndex == ActionViewMode.Action.toRaw() {
                    self.loadActionsToComplete()
                }
            } else {
                NSLog("Error getting actions: \(error)")
            }
        }
        
        ParseClient.sharedInstance.findCompleteActionsWithCompletion(nil) { (actions, error) -> () in
            if actions != nil {
                self.completed = actions
                if self.segmentedControl.selectedSegmentIndex == ActionViewMode.Completed.toRaw() {
                    self.loadCompleted()
                }
            } else {
                NSLog("Error getting actions: \(error)")
            }
        }
    }

    @IBAction func didChangeControl(sender: UISegmentedControl) {
        reloadTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentData != nil {
            return currentData!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("actionCell") as ActionTableViewCell
        let action = currentData![indexPath.row]
        cell.descriptionLabel.text = action.reason
        cell.actionTypeLabel.text = action.type.toRaw()
//        cell.configureCell(action)
        
//        cell.setNeedsLayout()
//        cell.setNeedsUpdateConstraints()
//        cell.updateConstraintsIfNeeded()
        NSLog("\(cell)")
        return cell
    }
    
    func reloadTableView() {
        if segmentedControl.selectedSegmentIndex == ActionViewMode.Action.toRaw() {
            loadActionsToComplete()
        } else if segmentedControl.selectedSegmentIndex == ActionViewMode.Completed.toRaw() {
            loadCompleted()
        }
    }
    
    func loadActionsToComplete() {
        if currentData == nil || currentData! != actions! {
            currentData = actions
            if currentData!.count > 0 {
                tableView.hidden = false
                emptyView.hidden = true
                tableView.reloadData()
            } else {
                emptyView.hidden = false
                tableView.hidden = true
                emptyView.type = .ActionToTake
            }
        }
    }
    func loadCompleted() {
        if currentData == nil || currentData! != completed! {
            currentData = completed
            if currentData!.count > 0 {
                tableView.hidden = false
                emptyView.hidden = true
                tableView.reloadData()
            } else {
                emptyView.hidden = false
                tableView.hidden = true
                emptyView.type = .CompletedAction
            }
        }
    }
    
}
