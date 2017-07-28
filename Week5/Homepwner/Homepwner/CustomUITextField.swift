//
//  CustomUITextField.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class CustomUITextField: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        
//        borderStyle = .bezel
        
        self.layer.cornerRadius = 5.0
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.borderWidth = 1.0

        return true
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        
//        borderStyle = .roundedRect
        
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.1
        
        return true
    }
}
