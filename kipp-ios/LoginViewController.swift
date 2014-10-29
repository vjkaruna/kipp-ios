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
    @IBOutlet weak var loggingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordField.secureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func loginTap(sender: AnyObject) {
        self.errorLabel.hidden = true
        self.loggingLabel.hidden = false
        var username = usernameField.text
        var password = passwordField.text
        
        ParseClient.sharedInstance.loginWithCompletion(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                println("login succeeded")
                self.errorLabel.hidden = true
                self.loggingLabel.hidden = true
                NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)

            } else {
                self.handleLoginError()
            }
        }
        
    }
    
    func handleLoginError() {
        self.loggingLabel.hidden = true
        self.errorLabel.hidden = false
        println("Error logging in")
    }
}

