//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by 김성준 on 2017. 7. 7..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var celsiusLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: Properties
    
    var fahrenheitValue: Double? {
        didSet {
            updateCelsiusLabel()
        }
    }
    var celsiusValue: Double? {
        if let value = fahrenheitValue {
            return (value - 32) * (5/9)
        }
        else {
            return nil
        }
    }
    
    let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    
    // MARK: View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversionViewController loaded its view")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
       view.backgroundColor = randomColor()
    }
    
    // MARK: Methods
    
    func updateCelsiusLabel() {
        if let value = celsiusValue {
            celsiusLabel.text = numberFormatter.string(from: NSNumber(value: value))
        }
        else {
            celsiusLabel.text = "???"
        }
    }
    
    func randomColor() -> UIColor {
        let colors = [UIColor.red, .orange, .yellow, .green, .blue, .purple, .brown, .white, .darkGray]
        let randomChoice = Int(arc4random_uniform(9))
        return colors[randomChoice]
    }
    
    // MARK: Actions
    
    @IBAction func fahrenheitFieldEditingChanged(textField: UITextField) {
        if let text = textField.text, let value = Double(text) {
            fahrenheitValue = value
        }
        else {
            fahrenheitValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let existingTextHasDecimalSeparator = textField.text?.range(of: ".")
        let replacementTextHasDecialSeparator = string.range(of: ".")
        let replacementTextHasLetters = string.rangeOfCharacter(from: NSCharacterSet.letters)
    
        if replacementTextHasLetters != nil {
            return false
        }
        else if existingTextHasDecimalSeparator != nil && replacementTextHasDecialSeparator != nil {
            return false
        }
        else
        {
            return true
        }
        
    }
    
}
