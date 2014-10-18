//
//  StudentTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class StudentTableViewCell: UITableViewCell, UIGestureRecognizerDelegate, StudentProfileChangedDelegate {
    
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    // add left and right constraint that's set by VC's pan gesture recognizer
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!

    @IBOutlet weak var animatingLayerView: UIView!
    
    var delegate: ProfileImageTappedDelegate?
    
    weak var student: Student? {
        willSet(newStudent) {
            if newStudent != nil {
                newStudent!.delegate = self
                self.displayName.text = "\(newStudent!.firstName) \(newStudent!.lastName)"
                newStudent!.fillAttendanceState() // If we want attendance for specific date, we can pass the date here
            }
        }
        didSet {
            setCellForState()
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
    func attendanceDidChange() {
        setCellForState()
    }
    
    func setCellForState() {
        if student != nil && student!.attendance != nil {
            switch student!.attendance! {
            case .Absent:
                NSLog("\(student!.firstName) is absent")
                self.animatingLayerView.backgroundColor = UIColor.redColor()
                self.animatingLayerView.alpha = 0.4
            default:
                self.animatingLayerView.backgroundColor = UIColor.whiteColor()
            }
        }
    }
    
    @IBAction func didTapAbsent(sender: UIButton) {
        NSLog("\(student!.firstName) is absent") // UPDATE or CREATE row in Attendance table entry (only one entry per day)
        UIView.animateWithDuration(0.5, animations: {
            self.rightConstraint.constant = 0
            self.leftConstraint.constant = 0
            self.animatingLayerView.backgroundColor = UIColor.redColor()
            self.animatingLayerView.alpha = 0.4
            self.contentView.layoutIfNeeded()
        })
        student!.markAsAbsent()
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
