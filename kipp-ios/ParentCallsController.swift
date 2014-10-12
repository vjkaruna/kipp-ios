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

    @IBOutlet var parentsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var teacher = PFUser.currentUser()
        
        parentsTable.delegate = self
        parentsTable.dataSource = self
        
        println("performing a Parse query")
        
        var classroomQuery = PFQuery(className: "Parent")
        
        classroomQuery.findObjectsInBackgroundWithBlock { (parents:[AnyObject]!, error: NSError!) -> Void in
            
            for obj in parents {
                var parent = Parent(obj: obj as PFObject)
                println("\(parent.firstName)")
                self.parents.append(parent)
            }
            self.parentsTable.reloadData()
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
        var callButtonLabel = cell.viewWithTag(102) as UIButton
        parentNameLabel.text = parents[indexPath.row].firstName

        return cell
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

}
