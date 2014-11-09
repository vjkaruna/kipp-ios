//
//  CallMenuViewController.swift
//  kipp-ios
//
//  Created by vli on 11/9/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CallMenuViewController: UIViewController {

    var delegate: CallMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapCallLater(sender: UIButton) {
        NSLog("Call later")
        delegate?.didTapCallLater()
    }

    @IBAction func didTapCallNow(sender: UIButton) {
        NSLog("Call now")
        delegate?.didTapCallNow()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
