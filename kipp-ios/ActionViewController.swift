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
//    let sectionHeaders = ["Today", "]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)
        
        ParseClient.sharedInstance.findIncompleteActionsWithCompletion(nil) { (actions, error) -> () in
            if actions != nil {
                self.actions = actions
//                self.currentData = actions
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
//                self.currentData = actions
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
    
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 3
//    }
//    
//    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        var headerView = UIView(frame: CGRect(x:0, y:0, width: tableView.frame.width, height: 50))
//        headerView.backgroundColor = UIColor(white: 0.8, alpha: 0.9)
//        //        headerView.backgroundColor = UIColor(red: CGFloat(218.0/255.0), green: 209.0/255.0, blue: CGFloat(215.0/255.0), alpha: 0.6)
//        var headerLabel = UILabel(frame: CGRect(x: 28, y: 0, width: tableView.frame.width, height: 50))
//        headerLabel.text = filterViewModel.getHeaderForSectionIdx(section)
//        headerLabel.textColor = UIColor(white: 0.1, alpha: 0.7)
//        headerLabel.font = UIFont(name: "Helvetica Bold", size: 16)
//        headerView.addSubview(headerLabel)
//        
//        return headerView
//    }
    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filterViewModel.getNumRowsInSection(section)
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("actionCell") as ActionTableViewCell
        let action = currentData![indexPath.row]
//        cell.descriptionLabel.text = action.reason
//        cell.actionTypeLabel.text = action.type.toRaw()
        cell.configureCell(action: action)
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
