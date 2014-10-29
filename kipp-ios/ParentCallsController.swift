//
//  ParentCallsController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/12/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ParentCallsController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    var parents = [Parent]()
    var selectedCells = [Bool]()
    var rowHeight = 64.0

    @IBOutlet var parentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var teacher = PFUser.currentUser()
        
        parentsTable.delegate = self
        parentsTable.dataSource = self
        
        navigationItem.title = "Phone Directory"
        println("performing a Parse query")
        
        ParseClient.sharedInstance.findParentsWithCompletion() {
            (parents:[Parent]?, error: NSError?) -> Void in
            if error == nil {
                self.parents = parents!
                self.selectedCells = Array(count:self.parents.count, repeatedValue:false)
                self.parentsTable.reloadData()
            } else {
                NSLog("ERROR getting parents data from Parse!")
            }
        }
    }

    @IBAction func callTouched(sender: AnyObject) {
        var callbutton = sender as UIButton
        var cell = callbutton.superview?.superview as UITableViewCell
        var indexPath = self.parentsTable.indexPathForCell(cell) as NSIndexPath!
        var parent = parents[indexPath.row]
        parent.lastCalledDate = NSDate()
        parentsTable.reloadData()
        self.dialNumber(parent.phone)
        
    }
    
    @IBAction func expandTouched(sender: AnyObject) {
        var expbutton = sender as UIButton
        var cell = expbutton.superview?.superview as UITableViewCell
        var indexPath = self.parentsTable.indexPathForCell(cell) as NSIndexPath!
        var lastCallLabel = cell.viewWithTag(201) as UILabel
        if (selectedCells[indexPath.row] == false) {
          selectedCells[indexPath.row] = true
          lastCallLabel.hidden = false
          parentsTable.beginUpdates()
          parentsTable.endUpdates()
        } else {
            selectedCells[indexPath.row] = false
            lastCallLabel.hidden = true
            parentsTable.beginUpdates()
            parentsTable.endUpdates()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return parents.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ParentCell", forIndexPath: indexPath) as UITableViewCell

        var parentNameLabel = cell.viewWithTag(101) as UILabel
        //var callButtonLabel = cell.viewWithTag(102) as UIButton
        parentNameLabel.text = parents[indexPath.row].fullName
        var studentNameLabel = cell.viewWithTag(103) as UILabel
        studentNameLabel.text = parents[indexPath.row].student?.fullName
        
        var lastCallLabel = cell.viewWithTag(201) as UILabel
        var dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MMM d, h:mm a"
        lastCallLabel.text = "Last Called  \(dateFormat.stringFromDate(parents[indexPath.row].lastCalledDate))"

        return cell
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (selectedCells[indexPath.row]) {
            return CGFloat(rowHeight + 70.0)
        } else {
            return CGFloat(rowHeight)
        }
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        self.performSegueWithIdentifier("showProfile", sender: parents[indexPath.row].student?)
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    func dialNumber(phonestr: String) {
        let telstr = "telprompt://\(phonestr)"
        UIApplication.sharedApplication().openURL(NSURL(string:telstr)!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "showProfile") {
            var profileVC = segue.destinationViewController as ProfileGraphViewController
            profileVC.student = sender as? Student
        }
    }

}
