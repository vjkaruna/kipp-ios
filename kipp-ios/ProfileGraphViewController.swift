//
//  ProfileGraphViewController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ProfileGraphViewController: UIViewController, GKLineGraphDataSource {
//class ProfileGraphViewController: UIViewController {


    @IBOutlet weak var graph: GKLineGraph!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //var frame = CGRectMake(0, 40, 320, 200)
        //self.graph = GKLineGraph(frame: frame)
        
        self.graph.dataSource = self
        self.graph.lineWidth = 3.0
        self.graph.width = 300
        self.graph.height = 300
        
        self.graph.draw()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
     func numberOfLines() -> Int {
        return 1
    }
    
    func colorForLineAtIndex(index: Int) -> UIColor! {
        var mcolors = [UIColor]()
        mcolors.append(UIColor.magentaColor())
        mcolors.append(UIColor.redColor())
        mcolors.append(UIColor.greenColor())
        return mcolors[index] as UIColor!
    }
    
    func valuesForLineAtIndex(index: Int) -> [AnyObject]! {
        var data = [2,30,40,70,50,40,80,120,50,3,40,60,90]
        return data
    }
    
    func animationDurationForLineAtIndex(index: Int) -> CFTimeInterval {
        return CFTimeInterval(3)
    }
    
    func titleForLineAtIndex(index: Int) -> String! {
        return "Math"
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
