//
//  AppDelegate.swift
//  kipp-ios
//
//  Created by Vijay Karunamurthy on 10/9/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        Parse.setApplicationId("kyHMOOZDxjNGJ6moZEoRz8WIygUT402Cr4nFgSzA", clientKey: "t32qn2VTGTm5EBCXqo85COvSj945wB5CAqi4KNje")
        
        if true { // FOR TESTING PURPOSES ONLY
            
            // TODO: Remove this when finished
            var storyboard = UIStoryboard(name: "ParentCalls", bundle: nil)
            
            PFUser.logInWithUsernameInBackground("vanessa", password:"test123") {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    println("login succeeded")
                    let vc = storyboard.instantiateViewControllerWithIdentifier("ParentCallsNC") as UIViewController
                    self.window?.rootViewController = vc
                } else {
                    // The login failed. Check error to see why.
                    println("login failed")
                }
            }
        }
        /**
        if true { // FOR TESTING PURPOSES ONLY
            
            // TODO: Remove this when finished
            var storyboard = UIStoryboard(name: "ClassRoster", bundle: nil)
            
            PFUser.logInWithUsernameInBackground("vanessa", password:"test123") {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    // Do stuff after successful login.
                    println("login succeeded")
                    let vc = storyboard.instantiateViewControllerWithIdentifier("ClassRosterNC") as UIViewController
                    self.window?.rootViewController = vc
                } else {
                    // The login failed. Check error to see why.
                    println("login failed")
                }
            }
        }
        **/
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

