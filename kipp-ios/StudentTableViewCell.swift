//
//  StudentTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    // add left and right constraint that's set by VC's pan gesture recognizer
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!

    var delegate: ProfileImageTappedDelegate?
    
    var student: Student? {
        willSet {
            self.displayName.text = "\(newValue!.firstName) \(newValue!.lastName)"
        }
    }
    
    var panLocation: CGPoint? {
        willSet {
            self.panLocation = newValue
            self.rightConstraint.constant += -newValue!.x
            NSLog("New x constraint \(self.rightConstraint.constant)")
        }
    }
    
    @IBAction func didTapAbsent(sender: UIButton) {
        NSLog("\(student!.firstName) is absent")
        // change color of cell?
    }
    
    @IBAction func didTapProfilePic(sender: AnyObject) {
        delegate?.didTapProfileImg(student!)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
