//
//  TabBarViewController.swift
//  kipp-ios
//
//  Created by dylan on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class TabBarViewController: UIViewController, UITabBarControllerDelegate, ClassroomSelectionDelegrate {

    var _viewControllers: [UIViewController]?
    let mainTabBarController = UITabBarController()
    var classroomsController: ClassroomsViewController?
    var presentingController: UIViewController?

    var presentingModal: Bool = false
    var reloadClassroom: (() -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTabBarController.delegate = self
        mainTabBarController.viewControllers = viewControllers()
        
        var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        
        button.frame = CGRect(x: 0.0, y: 0.0, width: 75.0, height: 75.0)
        button.backgroundColor = UIColor.kippBlue()
        button.layer.cornerRadius = 75/2.0
        var buttonImage = UIImageView(image: UIImage(named: "classroom-inverted"))
        var center = button.center
        center.y = center.y - 5
        buttonImage.center = center
        button.addSubview(buttonImage)
        
        
        button.center = self.mainTabBarController.tabBar.center
        self.mainTabBarController.view.addSubview(button)
        
        var buttonText: UILabel = UILabel(frame: CGRect(x: 10, y: 50, width: 75.0, height: 10.0))
        buttonText.text = "Classrooms"
        buttonText.textColor = UIColor.whiteColor()
        buttonText.font = UIFont.systemFontOfSize(10.0)
        button.addSubview(buttonText)

        
        button.addTarget(self, action: "onClickClassroomsButton", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if self.presentingModal {
            mainTabBarController.selectedViewController?.dismissViewControllerAnimated(false, completion: nil)
            self.presentingModal = false
        } else if (viewController == self.classroomsController) {
            onClickClassroomsButton()
        }
        return viewController != self.classroomsController
    }
    
    func onClickClassroomsButton() {
        let classroomSB = UIStoryboard(name: "ClassroomSelection", bundle: nil)
        let classroomsController = classroomSB.instantiateViewControllerWithIdentifier("classroomsVC") as ClassroomsViewController
        classroomsController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        classroomsController.delegate = self
        self.presentingController = mainTabBarController.selectedViewController
        mainTabBarController.selectedViewController?.presentViewController(classroomsController, animated: false, completion: nil)
        self.presentingModal = true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
            self.classroomsController?.delegate = self
            
            attendanceNavController.tabBarItem = UITabBarItem(title: "Attendance", image: UIImage(named: "attendance"), tag: 1)
            rosterNavController.tabBarItem = UITabBarItem(title: "Character", image: UIImage(named: "character"), tag: 1)
            actionNavController.tabBarItem = UITabBarItem(title: "Actions", image: UIImage(named: "alert"), tag: 1)
            callsNavController.tabBarItem = UITabBarItem(title: "Calls", image: UIImage(named: "phone"), tag: 1)
            classroomsController.tabBarItem = UITabBarItem(title: "Classes", image: UIImage(named: "classroom"), tag: 1)
            
            self.reloadClassroom = {() -> () in
                if (attendanceNavController as UINavigationController).viewControllers.count > 0 {
                    ((attendanceNavController as UINavigationController).viewControllers[0] as BaseClassroomViewController).loadClassroom()
                }
                if (rosterNavController as UINavigationController).viewControllers.count > 0 {
                    ((rosterNavController as UINavigationController).viewControllers[0] as BaseClassroomViewController).loadClassroom()
                }
                (attendanceNavController as UINavigationController).popToRootViewControllerAnimated(true)
                (rosterNavController as UINavigationController).popToRootViewControllerAnimated(true)
                (actionNavController as UINavigationController).popToRootViewControllerAnimated(true)
                return ()
            }

            
            self._viewControllers = [attendanceNavController, rosterNavController, classroomsController, actionNavController, callsNavController]
            
            mainTabBarController.tabBar.tintColor = UIColor.greenTint()
            //mainTabBarController.tabBar.barStyle = .Black
            mainTabBarController.tabBar.barTintColor = UIColor.darkBlue()
        }
        return self._viewControllers!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didSelectClassroom(classroom: Classroom) {
        NSLog("Did selected classroom: \(classroom)")
        mainTabBarController.selectedViewController?.dismissViewControllerAnimated(false, completion: nil)
//        if mainTabBarController.selectedIndex != 3 && mainTabBarController.selectedIndex != 5 {
//            let classroomVC = (mainTabBarController.selectedViewController! as UINavigationController).viewControllers[0] as BaseClassroomViewController
//            classroomVC.loadClassroom()
//        }
        self.reloadClassroom?()
        self.presentingModal = false
    }
}