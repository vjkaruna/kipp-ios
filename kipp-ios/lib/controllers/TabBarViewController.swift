//
//  TabBarViewController.swift
//  kipp-ios
//
//  Created by dylan on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, UITabBarControllerDelegate {

    var _viewControllers: [UIViewController]?
    let mainTabBarController = UITabBarController()
    var classroomsController: ClassroomsViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBarController.viewControllers = viewControllers()
    }
    
//    - (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
//    {
//    return viewController != self.sellTab;
//    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return viewController != self.classroomsController
    }
    
//    - (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
//    {
//    if (item == self.sellTab.tabBarItem) {
//    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:[[PostAdViewController alloc] init]] animated:YES completion:nil];
//    }
//    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if (viewController == self.classroomsController) {
            self.presentViewController(self.classroomsController!, animated: true, completion: nil)
        }
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
            
            let attendanceSB = UIStoryboard(name: "Attendance", bundle: nil)
            let attendanceNavController = attendanceSB.instantiateViewControllerWithIdentifier("AttendanceNC") as UIViewController

            let actionSB = UIStoryboard(name: "Actions", bundle: nil)
            let actionNavController = actionSB.instantiateViewControllerWithIdentifier("ActionNC") as UIViewController
            
            let classroomSB = UIStoryboard(name: "ClassroomSelection", bundle: nil)
            let classroomsController = classroomSB.instantiateViewControllerWithIdentifier("classroomsVC") as ClassroomsViewController
            self.classroomsController = classroomsController
            
            attendanceNavController.tabBarItem = UITabBarItem(title: "Attendance", image: UIImage(named: "attendance"), tag: 1)
            rosterNavController.tabBarItem = UITabBarItem(title: "Character", image: UIImage(named: "character"), tag: 1)
            actionNavController.tabBarItem = UITabBarItem(title: "Actions", image: UIImage(named: "alert"), tag: 1)
            callsNavController.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "phone"), tag: 1)
            classroomsController.tabBarItem = UITabBarItem(title: "Classes", image: UIImage(named: "classroom"), tag: 1)

            
            self._viewControllers = [actionNavController, attendanceNavController, classroomsController, rosterNavController, callsNavController]
            
            mainTabBarController.tabBar.tintColor = UIColor.greenTint()
            mainTabBarController.tabBar.barStyle = .Black
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
