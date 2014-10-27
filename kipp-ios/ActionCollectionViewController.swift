//
//  ActionCollectionViewController.swift
//  kipp-ios
//
//  Created by vli on 10/26/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let actions: [ActionType] = [.Celebrate, .Encourage, .Call, .History]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("actionTypeCell", forIndexPath: indexPath) as ActionCollectionViewCell
        let action = actions[indexPath.row]
        cell.tileLabel.text = action.toRaw()
        cell.iconImagView.image = UIImage(named: action.getIconName())
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenRect = UIScreen.mainScreen().bounds
        let width = collectionView.bounds.size.width
        let height = collectionView.bounds.size.height
        return CGSizeMake(CGFloat(width/2.0 - 15.0), CGFloat(height/2.0 - 45.0))
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        NSLog("Selected me!")
        let actionType = actions[indexPath.row]
        let actionSB = UIStoryboard(name: "Actions", bundle: nil)
        let actionVC = actionSB.instantiateViewControllerWithIdentifier("actionVC") as ActionViewController
        
        actionVC.actionType = actionType
        self.navigationController?.pushViewController(actionVC, animated: true)
    }


}
