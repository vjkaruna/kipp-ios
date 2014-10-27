//
//  ActionViewController.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MGSwipeTableCellDelegate {
// TODO: Need to pull out current class context into User model so we can query students
// Should this be an agenda view instead??
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var actionType: ActionType?
    
    var data: [Action]?
    
    var emptyView: EmptyDataView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.title = actionType?.toRaw()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        emptyView = UINib(nibName: "EmptyDataView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as EmptyDataView
        emptyView.hidden = true
        contentView.addSubview(emptyView)
        
        if actionType! != ActionType.History {
            ParseClient.sharedInstance.findIncompleteActionsWithCompletion(actionType!) { (actions, error) -> () in
                NSLog("Completion called for action type \(self.actionType!.toRaw())")
                if actions != nil {
                    self.data = actions
                    self.loadDataOrEmptyState()
                } else {
                    NSLog("Error getting actions: \(error)")
                }
            }
        } else {
            ParseClient.sharedInstance.findCompleteActionsWithCompletion(nil) { (actions, error) -> () in
                if actions != nil {
                    self.data = actions
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("actionCell") as ActionTableViewCell
        let action = data![indexPath.row]
        cell.descriptionLabel.text = action.reason
        cell.actionTypeLabel.text = action.type.toRaw()
//        NSLog("\(cell)")
        cell.delegate = self
        cell.rightButtons = createRightButton()
//        cell.leftButtons = []
//        cell.leftSwipeSettings.transition = MGSwipeTransition.TransitionDrag
        cell.rightSwipeSettings.transition = MGSwipeTransition.TransitionBorder
        cell.rightExpansion.buttonIndex = 0
        cell.rightExpansion.fillOnTrigger = true
        return cell
    }
    
    
    func loadDataOrEmptyState() {
        if data!.count > 0 {
            tableView.hidden = false
            emptyView.hidden = true
            tableView.reloadData()
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
        var anotherbutton = MGSwipeButton(title: "Done", backgroundColor: UIColor.greenTint()) { (cell) -> Bool in
            NSLog("Tapped Done for \(cell)")
            return true
        }
        var button = MGSwipeButton(title: "Delete", backgroundColor: UIColor.myRedColor()) { (cell) -> Bool in
            NSLog("Tapped delete for \(cell)")
            self.markActionComplete(self.tableView.indexPathForCell(cell)!)
            return true
        }
        return [button, anotherbutton]
    }

    func markActionComplete(indexPath: NSIndexPath) {
        let action = data![indexPath.row]
        ParseClient.sharedInstance.markActionAsComplete(action) { (success, error) -> () in
            NSLog("Updated object in Parse")
        }
        
        NSLog("Removing cell at \(indexPath.row)")
        data!.removeAtIndex(indexPath.row)
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
        tableView.endUpdates()
        
        loadDataOrEmptyState()
    }
//    -(void) deleteMail:(NSIndexPath *) indexPath
//    {
//    [demoData removeObjectAtIndex:indexPath.row];
//    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//    }
//    -(NSArray *) createLeftButtons: (int) number
//    {
//    NSMutableArray * result = [NSMutableArray array];
//    UIColor * colors[3] = {[UIColor greenColor],
//    [UIColor colorWithRed:0 green:0x99/255.0 blue:0xcc/255.0 alpha:1.0],
//    [UIColor colorWithRed:0.59 green:0.29 blue:0.08 alpha:1.0]};
//    UIImage * icons[3] = {[UIImage imageNamed:@"check.png"], [UIImage imageNamed:@"fav.png"], [UIImage imageNamed:@"menu.png"]};
//    for (int i = 0; i < number; ++i)
//    {
//    MGSwipeButton * button = [MGSwipeButton buttonWithTitle:@"" icon:icons[i] backgroundColor:colors[i] padding:15 callback:^BOOL(MGSwipeTableCell * sender){
//    NSLog(@"Convenience callback received (left).");
//    return YES;
//    }];
//    [result addObject:button];
//    }
//    return result;
//    }
//    
//    
//    -(NSArray *) createRightButtons: (int) number
//    {
//    NSMutableArray * result = [NSMutableArray array];
//    NSString* titles[2] = {@"Delete", @"More"};
//    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
//    for (int i = 0; i < number; ++i)
//    {
//    MGSwipeButton * button = [MGSwipeButton buttonWithTitle:titles[i] backgroundColor:colors[i] callback:^BOOL(MGSwipeTableCell * sender){
//    NSLog(@"Convenience callback received (right).");
//    return YES;
//    }];
//    [result addObject:button];
//    }
//    return result;
//    }
}
