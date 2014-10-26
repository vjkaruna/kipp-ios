//
//  ClassroomSelectionViewController.swift
//  kipp-ios
//
//  Created by dylan on 10/25/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ClassroomSelectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 280, height: 135)
        var a = CGRect(x: 0, y: 0, width: 300, height: 540)
        collectionView = UICollectionView(frame: a, collectionViewLayout: layout)
        collectionView!.dataSource = self
        collectionView!.delegate = self
        collectionView!.registerClass(ClassroomCollectionViewCell.self, forCellWithReuseIdentifier: "ClassroomSelection")
        collectionView!.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(collectionView!)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ClassroomSelection", forIndexPath: indexPath) as ClassroomCollectionViewCell
        cell.backgroundColor = UIColor.kippBlue()
        return cell
    }
}
