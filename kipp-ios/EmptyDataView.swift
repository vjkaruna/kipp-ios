//
//  EmptyDataView.swift
//  kipp-ios
//
//  Created by vli on 10/25/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {

//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
    
    enum EmptyType {
        case CompletedAction
        case ActionToTake
        case Attendance
    }
    var type: EmptyType? {
        didSet(value){
            switch(self.type!){
            case .CompletedAction:
                descriptionLabel.text = "No actions completed yet in this class"
                tipLabel.text = "Swipe to complete actions in Actions tab"
            case .ActionToTake:
                descriptionLabel.text = "No actions to take for students in this class"
                tipLabel.text = "Call, Celebrate, or Encourage students"
            case .Attendance:
                descriptionLabel.text = "Attendance complete!"
                tipLabel.text = "Tap the edit button to make changes and to see today's attendance"
            }
        }
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tipLabel: UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
