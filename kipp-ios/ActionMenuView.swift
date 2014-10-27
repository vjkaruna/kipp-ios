//
//  ActionMenuView.swift
//  kipp-ios
//
//  Created by vli on 10/26/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ActionMenuView: UIView {

    @IBOutlet weak var cancelButton: UIButton!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
