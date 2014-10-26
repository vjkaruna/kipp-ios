//
//  ReasonViewController.swift
//  kipp-ios
//
//  Created by vli on 10/25/14.
//  Copyright (c) 2014 vjkaruna. All rights reserved.
//

import UIKit

class ReasonViewController: UIViewController, UITextViewDelegate {
    var delegate: ReasonSubmittedDelegate?
    
    @IBOutlet weak var alertView: UIView!
//    @IBOutlet weak var actionLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var textField: UITextView!
    
    @IBOutlet weak var buttonsView: UIView!
    
    var actionType: ActionType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alertView.layer.cornerRadius = 5
        alertView.layer.borderWidth = 1.0
        alertView.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
//        self.layer.cornerRadius = 5
//        self.layer.borderWidth = 1.0
//        self.layer.borderColor = UIColor(white: 0.7, alpha: 0.7).CGColor
        // Do any additional setup after loading the view.
//        switch(self.actionType!){
//        case .Celebrate:
//            actionLabel.text = "Celebrate this student"
//        case .Encourage:
//            actionLabel.text = "Encourage this student"
//        case .Call:
//            actionLabel.text = "Call parents"
//        }
        textField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapSubmit(sender: UIButton) {
        delegate?.didTapSubmitButton(textField.text)
    }

    @IBAction func didDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView) {
        if textField.text.isEmpty {
            placeholderLabel.hidden = false
        } else {
            placeholderLabel.hidden = true
        }
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
