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
    @IBOutlet weak var slider: UISlider!
    
    var score: Int? {
        willSet {
            let value = newValue ?? 0
            if value < 0 {
                scoreLabel.textColor = UIColor(red: CGFloat(204.0/255.0), green: CGFloat(26.0/255.0), blue: CGFloat(20.0/255.0), alpha: CGFloat(1))
            }
            scoreLabel.text = "\(value)"
            slider.value = Float(value)
        }
    }
    var row: Int!
    
    var delegate: CharacterTraitUpdatedDelegate?
    
    var characterTrait: CharacterTrait? {
        willSet {
            characterImgView.image = UIImage(named: newValue!.imgName)
        }
    }
    @IBAction func sliderDidChange(sender: UISlider) {
        let sliderValue = Int(sender.value)
        scoreLabel.text = "\(sliderValue)"
        delegate?.traitScoreDidUpdate(sliderValue, forRow: row)
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
