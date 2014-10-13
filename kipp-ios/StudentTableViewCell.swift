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

    @IBOutlet weak var animatingLayerView: UIView!
    
    var delegate: ProfileImageTappedDelegate?
    
    var student: Student? {
        willSet {
            self.displayName.text = "\(newValue!.firstName) \(newValue!.lastName)"
        }
    }
    
    var xPanLocation: CGFloat = 0 {
        willSet {
//            self.panLocation = newValue
            if self.xPanLocation < newValue {
                let newConstraintVal = max(self.rightConstraint.constant - newValue, 0)
                self.rightConstraint.constant = newConstraintVal
                self.leftConstraint.constant = -newConstraintVal
                NSLog("Pan right?? New x constraint \(newConstraintVal)")
            } else if self.xPanLocation > newValue {
                let newConstraintVal = min(self.rightConstraint.constant - newValue, self.frame.width)
                self.rightConstraint.constant = newConstraintVal
                self.leftConstraint.constant = -newConstraintVal
                NSLog("Pan left?? New x constraint \(newConstraintVal)")
            }
        }
    }
    
    @IBAction func didTapAbsent(sender: UIButton) {
        NSLog("\(student!.firstName) is absent")
        UIView.animateWithDuration(0.5, animations: {
            self.rightConstraint.constant = 0
            self.leftConstraint.constant = 0
            self.contentView.layoutIfNeeded()
        })
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
