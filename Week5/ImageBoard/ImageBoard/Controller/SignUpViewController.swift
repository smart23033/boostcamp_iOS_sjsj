//
//  SignUpViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 29..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Properties

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    
  }

//MARK: Life Cycle

extension SignUpViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

//MARK: Actions

extension SignUpViewController {
    
    @IBAction func touchUpSignUpButton(_ sender: UIButton) {
        self.endEditing()
        
        guard let email: String = self.emailField.text,
            let name: String = self.nameField.text,
            let password: String = self.passwordField.text,
            let checkPassword: String = self.passwordCheckField.text else {
                return
        }
        
        guard !email.isEmpty || !name.isEmpty || !password.isEmpty || !checkPassword.isEmpty else {
            let alert = UIAlertController.init(title: nil, message: "모든 항목을 입력하세요", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard password == checkPassword else {
            let alert = UIAlertController.init(title: nil, message: "암호와 암호확인이 일치하지 않습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction.init(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        
        let user = User(email: email, password: password, nickname: name)
        
        NetworkManager.shared.fetchSignUpInfo(user: user){
            (result) -> Void in
            
            switch result {
            case let .success(user):
                print("sign up success")
                print("id: \(user._id), nickname: \(user.nickname)")
                
                // alert이 네비가 pop되고 나타나야 함
                let alert = UIAlertController.init(title: nil, message: "회원가입 완료", preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                    _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion:nil)
                
            case let .failure(error):
                print("sign up error")
                print("error: \(error)")
                
                let errorMessage = "\(error)"
                
                let alert = UIAlertController.init(title: "알림", message: errorMessage, preferredStyle: .alert)
                let okAction = UIAlertAction.init(title: "OK", style: .default, handler: {
                    _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(okAction)
                self.present(alert, animated: true, completion:nil)
            }
            
        }
        
    }
}

//MARK: Functions

extension SignUpViewController {
    
    func endEditing() {
        
        self.view.subviews.forEach {
            if $0.isFirstResponder, $0.responds(to: #selector(UIView.self.endEditing)) {
                $0.endEditing(true)
            }
        }
        
    }
}
