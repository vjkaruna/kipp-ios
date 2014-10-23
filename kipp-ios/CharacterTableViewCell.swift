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
    @IBOutlet weak var characterLabel: UILabel!
    
    var score: Int? {
        willSet {
            let value = newValue ?? 0
            setColorForScore(value)
            scoreLabel.text = "\(value)"
            slider.value = Float(value)
        }
    }
    var row: Int!
    
    var delegate: CharacterTraitUpdatedDelegate?
    
    var characterTrait: CharacterTrait? {
        willSet {
            characterImgView.image = UIImage(named: newValue!.imgName)
            characterLabel.text = newValue!.title
        }
    }
    @IBAction func sliderDidChange(sender: UISlider) {
        let sliderValue = Int(sender.value)
        setColorForScore(sliderValue)
        scoreLabel.text = "\(sliderValue)"
        delegate?.traitScoreDidUpdate(sliderValue, forRow: row)
    }

    func setColorForScore(score: Int) {
        if score < 0 {
            scoreLabel.textColor = UIColor.myRedColor()
        } else {
            scoreLabel.textColor = UIColor.whiteColor()
        }
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
