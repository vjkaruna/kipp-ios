//
//  ActionViewController.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
// TODO: Need to pull out current class context into User model so we can query students
// Should this be an agenda view instead??
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var actions: [Action]?
    
    let views = ["By Date", "By Action", "History"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        ParseClient.sharedInstance.findIncompleteActionsWithCompletion(nil) { (actions, error) -> () in
            if actions != nil {
                self.actions = actions
                self.tableView.reloadData()
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
        if actions != nil {
            return actions!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("actionCell") as ActionTableViewCell
        let action = actions![indexPath.row]
        cell.descriptionLabel.text = action.reason
        cell.actionTypeLabel.text = action.type.toRaw()
        return cell
    }
    
    func reloadTableView() {
        switch views[segmentedControl.selectedSegmentIndex] {
        case "By Date":
            loadByDate()
        case "By Action":
            loadByAction()
        case "History":
            loadByHisotry()
        default:
            loadByDate()
        }
    }
    
    func loadByDate() {
        NSLog("Date")
    }
    func loadByAction() {
        NSLog("Action")
    }
    func loadByHisotry() {
        NSLog("Histroy")
    }
    
//    
//    func didPostTweet(tweet: Tweet) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        println(tweet.text)
//        insertTweetAtTop(tweet)
//    }
//    
//    func insertTweetAtTop(tweet: Tweet) {
//        tweets?.insert(tweet, atIndex: 0)
//        tableView.reloadData()
//    }
}
