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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogout", name: userDidLogoutNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "userDidLogin", name: userDidLoginNotification, object: nil)
        
        if (ParseClient.sharedInstance.getCurrentUser() != nil) {
            userDidLogin()
        }
        
        UINavigationBar.appearance().barTintColor = UIColor.kippBlue()
        UINavigationBar.appearance().barStyle = .Black
        UINavigationBar.appearance().tintColor = UIColor.greenTint()
        
        let titleAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 17)]
        UINavigationBar.appearance().titleTextAttributes = titleAttributes
//        UILabel.appearance().textColor = UIColor.kippBlue()
//        UILabel.appearance().font = UIFont(name: "HelveticaNeue-CondensedBold", size: 17)
        
        return true
    }
    
    func userDidLogin() {
        window?.rootViewController = TabBarViewController()
    }
    
    func userDidLogout() {
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginScreen") as UIViewController
        self.window?.rootViewController = vc
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

