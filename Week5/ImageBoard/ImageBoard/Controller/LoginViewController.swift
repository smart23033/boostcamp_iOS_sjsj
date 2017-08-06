//
//  ViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 29..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: LoginDelegate

protocol LoginDelegate {
    func didLoginSuccess(user: User)
}

//MARK: Properties

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var loginDelegate: LoginDelegate?
    
    var email: String! {
        return emailField.text!
    }
    var password: String! {
        return passwordField.text!
    }
    
}

//MARK: Life Cycle

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
}

//MARK: Actions

extension LoginViewController {
    
    @IBAction func touchUpLoginButton(_ sender: UIButton) {
        self.endEditing()
        
        let user = User(email: email, password: password)
        
        NetworkManager.shared.fetchLoginInfo(user: user) {
            (result) -> Void in
            
            switch result {
            case let .success(user):
                print("login success")
                print("id: \(user._id), nickname: \(user.nickname)")
                self.loginDelegate?.didLoginSuccess(user: user)
                self.dismiss(animated: true, completion: nil)
            case let .failure(error):
                print("login error")
                print("error: \(error)")
                
                let errorMessage = "\(error)"
                
                let alert = UIAlertController.init(title: "알림", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true, completion:nil)
            }
            
        }
        
        
    }
    
}

//MARK: Functions

extension LoginViewController {
    
    func endEditing() {
        
        self.view.subviews.forEach {
            if $0.isFirstResponder, $0.responds(to: #selector(UIView.self.endEditing)) {
                $0.endEditing(true)
            }
        }
        
    }
}

//MARK: Segues

extension LoginViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
}
