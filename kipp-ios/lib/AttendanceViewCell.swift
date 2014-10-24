//
//  AttendanceViewCell.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceViewCell: UITableViewCell {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!

    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var studentNameLabel: UILabel!
    @IBAction func onTardy(sender: AnyObject) {
        println("tardy")
    }
    
    @IBAction func onPresent(sender: AnyObject) {
        println("tardy")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func adjustBGColor(amount: CGFloat) {
        let magic_threshold:CGFloat = 140
        if amount < -magic_threshold {
            self.bgView.backgroundColor = UIColor.myRedColor()
        } else if amount > magic_threshold {
            self.bgView.backgroundColor = UIColor.greenTint()
        } else {
            self.bgView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    func moveCell(amount: CGFloat) {
        leadingConstraint.constant = amount
        trailingConstraint.constant = -amount
        adjustBGColor(amount)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.adjustBGColor(0)
        self.layoutIfNeeded()
    }
}
