//
//  ViewController.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/9/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var message = PFObject(className: "TestObject")
//        message["text"] = "testing Parse"
//        message.saveInBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginTap(sender: AnyObject) {
        var username = usernameField.text
        var password = passwordField.text
        
        PFUser.logInWithUsernameInBackground(username, password:password) {
            (user: PFUser!, error: NSError!) -> Void in
            if user != nil {
                // Do stuff after successful login.
                println("login succeeded")
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)

            } else {
                self.handleLoginError()
            }
        }
        
    }
    
    func handleLoginError() {
        self.errorLabel.hidden = false
        println("Error logging in")
    }
}

