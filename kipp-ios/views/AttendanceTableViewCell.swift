//
//  AttendanceTableViewCell.swift
//  kipp-ios
//
//  Created by dylan on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class AttendanceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var studentLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBAction func onTardy(sender: AnyObject) {
        tardy()
    }
    @IBAction func onPresent(sender: AnyObject) {
        present()
    }
    
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    @IBOutlet weak var xConstraint2: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var mark: ((status: Status) -> Void)?
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func present() {
        self.mark?(status: .Present)
    }
    
    func tardy() {
        self.mark?(status: .Tardy)
    }
    
    func adjustColor(amount: CGFloat) {
        if abs(amount) < 144 {
            self.bgView.backgroundColor = UIColor.whiteColor()
        } else if amount < -144 {
            self.bgView.backgroundColor = UIColor(red: 253.0/255, green: 134.0/255, blue: 170.0/255, alpha: 1.0)
        } else if amount > 144 {
            self.bgView.backgroundColor = UIColor(red: 105.0/255, green: 255.0/255, blue: 111.0/255, alpha: 1)
        }
    }
    
    func move(amount: CGFloat) {
        self.xConstraint.constant = amount
        self.xConstraint2.constant = -amount
        self.adjustColor(amount)
    }
    
    func setup(student:Studentz, mark: ((status: Status) -> Void)) {
        self.studentLabel.text = student.name
        self.mark = mark
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.adjustColor(0)
        self.layoutIfNeeded()
    }
}
