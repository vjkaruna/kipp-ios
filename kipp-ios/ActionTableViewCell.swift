//
//  ActionTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/23/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionTableViewCell: JASwipeCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var actionTypeLabel: UILabel!
    
    weak var student: Student?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let actionView = UINib(nibName: "ActionCellView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ActionCellView
        self.contentView.addSubview(actionView)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(student: Student, action: Action) {
        let actionView = UINib(nibName: "ActionCellView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as ActionCellView
        actionView.profileImg.image = UIImage(named: student.gender.profileImg())
        actionView.reasonLabel.text = action.reason
        actionView.studentName.text = student.fullName
        
        self.contentView.addSubview(actionView)
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
