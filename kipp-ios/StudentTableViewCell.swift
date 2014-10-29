//
//  StudentTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/11/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class StudentTableViewCell: MGSwipeTableCell, StudentProfileChangedDelegate {
    
    @IBOutlet weak var attendanceImageView: UIImageView!
    @IBOutlet weak var dateCompleteLabel: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var actionComments: UILabel!
    
    var profileDelegate: ProfileImageTappedDelegate?
    
    var showAttendanceState: Bool = false

    weak var student: Student? {
        willSet(newStudent) {
            if newStudent != nil {
                newStudent!.delegate = self
                self.displayName.text = "\(newStudent!.firstName) \(newStudent!.lastName)"
                self.profilePic.image = UIImage(named: newStudent!.gender.profileImg())
                self.labelView.layer.cornerRadius = 5
                self.labelView.layer.borderWidth = 1.0
                self.labelView.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
                self.dateCompleteLabel.text = ""
                if self.showAttendanceState {
                    if newStudent!.attendance == nil {
                        newStudent!.fillAttendanceState() // If we want attendance for specific date, we can pass the date here
                    } else {
                        self.attendanceImageView.image = UIImage(named: newStudent!.attendance!.getIcon())
                        self.attendanceImageView.hidden = false
                    }
                } else {
                    self.attendanceImageView.hidden = true
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layoutIfNeeded()
        self.labelView.layoutIfNeeded()
        
        self.actionComments.preferredMaxLayoutWidth = self.actionComments.frame.size.width
        super.layoutSubviews()
    }
//    - (void)layoutSubviews
//    {
//    [super layoutSubviews];
//    [self.contentView layoutIfNeeded];
//    self.myLabel.preferredMaxLayoutWidth = self.myLabel.frame.size.width;
//    }
//    
    @IBAction func didTapProfilePic(sender: AnyObject) {
        profileDelegate?.didTapProfileImg(student!)
    }
    
    func attendanceDidChange() {
        self.attendanceImageView.image = UIImage(named: student!.attendance!.getIcon())
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
