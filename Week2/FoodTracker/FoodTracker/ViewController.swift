//
//  ViewController.swift
//  FoodTracker
//
//  Created by 김성준 on 2017. 7. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    //    MARK: Properties
    @IBOutlet weak var mealNameLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
    }
    
    //    MARK:UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        mealNameLabel.text = textField.text
    }
    
    //    MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        mealNameLabel.text = "Default Text"
    }

}

