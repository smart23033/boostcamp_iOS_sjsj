//
//  ViewController.swift
//  Login
//
//  Created by 김성준 on 2017. 7. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    //    MARK: Properties
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        idTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    //    MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //    MARK: Actions
    @IBAction func signIn(_ sender: UIButton) {
        print("touch up inside - sign in")
        print("ID : \(idTextField.text!), PW : \(passwordTextField.text!)" )
    }
    @IBAction func signUp(_ sender: UIButton) {
        print("touch up inside - sign up")
    }

}

