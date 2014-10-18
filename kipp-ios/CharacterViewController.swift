//
//  CharacterViewController.swift
//  kipp-ios
//
//  Created by vli on 10/14/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

enum CharacterTrait: Int {
    case Curiosity = 0, Gratitude, Grit, Optimism, SelfControl, SocialIntelligence, Zest
    
    func getAsset() -> String {
        switch self {
        case Curiosity:
            return "character-curiosity2"
        case .Gratitude:
            return "character-gratitude2"
        case .Grit:
            return "character-grit2"
        case .Optimism:
            return "character-optimism2"
        case .SelfControl:
            return "character-self-control2"
        case .SocialIntelligence:
            return "character-social-intelligence2"
        case .Zest:
            return "character-zest2"
        }
    }
    func getRoundAsset() -> String {
        switch self {
        case Curiosity:
            return "character-curiosity"
        case .Gratitude:
            return "character-gratitude"
        case .Grit:
            return "character-grit"
        case .Optimism:
            return "character-optimism"
        case .SelfControl:
            return "character-self-control"
        case .SocialIntelligence:
            return "character-social-intelligence"
        case .Zest:
            return "character-zest"
        }
    }
    
    static let all = [Curiosity, Gratitude, Grit, Optimism, SelfControl, SocialIntelligence, Zest]
}

class CharacterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var student: Student?
    
    @IBOutlet weak var tableView: UITableView!
    
//    @IBOutlet weak var characterView: CharacterView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self

//        var view = UINib(nibName: "CharacterView", bundle: nil).instantiateWithOwner(self, options: nil)[0] as CharacterView
//        var image = UIImage(named: "character-curiosity")
//        image.view.frame = CGRectMake(0, 0, 35, 35)
//        view.thumbImage = image
//        view.frame = CGRectMake(0, 0, self.view.bounds.size.width, 80)
//        characterView.thumbImage = image
//        self.view.addSubview(view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CharacterTrait.all.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("characterCell") as CharacterTableViewCell
        let trait = CharacterTrait.fromRaw(indexPath.row)
        cell.characterTrait = trait!
        return cell
    }
    
    @IBAction func didTapSave(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
        // Save to Parse here!
    }
    
    @IBAction func didTapCancel(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
