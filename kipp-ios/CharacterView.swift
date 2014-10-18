//
//  CharacterView.swift
//  kipp-ios
//
//  Created by vli on 10/15/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CharacterView: UIView {

    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var slider: UISlider!
    
    var thumbImage: UIImage? {
        willSet {
            slider.setThumbImage(newValue!, forState: .Normal)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        slider.setThumbImage(thumbImage, forState: .Normal)
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
