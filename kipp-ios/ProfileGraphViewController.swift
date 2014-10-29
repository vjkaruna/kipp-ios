//
//  ProfileGraphViewController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ProfileGraphViewController: UIViewController, GKLineGraphDataSource, StudentProfileChangedDelegate {
//class ProfileGraphViewController: UIViewController {

    var student: Student?

    @IBOutlet weak var graph: GKLineGraph!
    @IBOutlet weak var studentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var frame = CGRectMake(0, 40, 320, 200)
        //self.graph = GKLineGraph(frame: frame)
        
        if self.student != nil {
            self.student!.delegate = self
            self.student!.fillWeeklyProgress()
        }
        
        self.graph.dataSource = self
        self.graph.lineWidth = 3.0
        

        //self.graph.height = self.graph.frame.height
        //self.graph.width = self.graph.frame.width
        
        println("h: \(self.graph.height) w: \(self.graph.width)")
        self.graph.draw()
        
        if (student != nil) {
            studentLabel.text = student!.fullName
        }
    }

    func attendanceDidChange() {
        
    }
    func weeklyProgressDidChange() {
        self.graph.reset()
        self.graph.draw()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfLines() -> Int {
        return 2
    }
    
    func colorForLineAtIndex(index: Int) -> UIColor! {
        var mcolors = [UIColor]()
        mcolors.append(UIColor.magentaColor())
        mcolors.append(UIColor.redColor())
        mcolors.append(UIColor.greenColor())
        return mcolors[index] as UIColor!
    }
    
    func valuesForLineAtIndex(index: Int) -> [AnyObject]! {
        var data = [Int]()

        if (self.student != nil && self.student!.weeklyProgress != nil) {
            for progress in self.student!.weeklyProgress! {
                if index == 0 {
                    data.append(progress.minutes)
                } else {
                    data.append(Int(progress.weeklyProgress))
                }
            }
            
        } else {
            // default data
            if (index == 0) {
               data = [2,30,40,70,50,40,80,120,50,3,40,60,90]
            } else {
               data = [12,36,62,91,84,75,79,96,57,47,39,56,75]
            }
        }
        return data
    
    }
    
    func animationDurationForLineAtIndex(index: Int) -> CFTimeInterval {
        return CFTimeInterval(3)
    }
    
    func titleForLineAtIndex(index: Int) -> String! {
        return "\(index)"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
