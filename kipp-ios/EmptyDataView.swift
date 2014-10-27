//
//  EmptyDataView.swift
//  kipp-ios
//
//  Created by vli on 10/25/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {
    enum EmptyType {
        case CompletedAction
        case ActionToTake
        case Attendance
    }
    var type: EmptyType? {
        didSet(value){
            switch(self.type!){
            case .CompletedAction:
                descriptionLabel.text = "No actions completed yet"
                tipLabel.text = "Swipe to mark actions as complete"
                imageview.image = UIImage(named: "checkmark")
            case .ActionToTake:
                if actionType! == ActionType.Celebrate {
                    descriptionLabel.text = "No students to celebrate"
                    tipLabel.text = "Mark students for Celebration in the Character tab"
                } else if actionType! == .Encourage {
                    descriptionLabel.text = "No students to encourage"
                    tipLabel.text = "Mark students who need work in the Character tab"
                } else if actionType! == .Call {
                    descriptionLabel.text = "No parents to call"
                    tipLabel.text = "Keep parents informed of student progress by marking students to call in the Character tab"
                }
                imageview.image = UIImage(named: "exclamation")
            case .Attendance:
                descriptionLabel.text = "Attendance complete!"
                tipLabel.text = "Tap the edit button to make changes and to see today's attendance"
                imageview.image = UIImage(named: "checkmark")
            }
        }
    }
    
    var actionType: ActionType?

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var imageview: UIImageView!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
