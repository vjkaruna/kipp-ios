//
//  TabBarViewController.swift
//  kipp-ios
//
//  Created by dylan on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController {

    var _viewControllers: [UIViewController]?
    let mainTabBarController = UITabBarController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBarController.viewControllers = viewControllers()
    }
    
    override func viewDidAppear(animated: Bool) {
        mainTabBarController.viewControllers = viewControllers()
        self.presentViewController(mainTabBarController, animated: false, completion: nil)

    }
    
    func viewControllers() -> [UIViewController] {
        if self._viewControllers == nil {
            let classRosterSB = UIStoryboard(name: "ClassRoster", bundle: nil)
            let rosterNavController = classRosterSB.instantiateViewControllerWithIdentifier("ClassroomNC") as UIViewController
            
            let parentCallsSB = UIStoryboard(name: "ParentCalls", bundle: nil)
            let callsNavController = parentCallsSB.instantiateViewControllerWithIdentifier("ParentCallsNC") as UIViewController
            
            rosterNavController.tabBarItem = UITabBarItem(title: "roster", image: nil, tag: 1)
            callsNavController.tabBarItem = UITabBarItem(title: "calls", image: nil, tag: 1)
            
            self._viewControllers = [rosterNavController, callsNavController]
        }
        return self._viewControllers!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
