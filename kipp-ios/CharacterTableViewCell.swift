//
//  CharacterTableViewCell.swift
//  kipp-ios
//
//  Created by vli on 10/16/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImgView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var characterTrait: CharacterTrait? {
        willSet {
            characterImgView.image = UIImage(named: newValue!.getRoundAsset())
        }
    }
    @IBAction func sliderDidChange(sender: UISlider) {
        let sliderValue = Int(sender.value)
        scoreLabel.text = "\(sliderValue)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        scoreLabel.text = "0"
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
