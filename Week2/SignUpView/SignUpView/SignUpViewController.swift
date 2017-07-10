//
//  SignUpViewController.swift
//  SignUpView
//
//  Created by 김성준 on 2017. 7. 10..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        idTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Methods
    
     // Hide the keyboard.
    func hideKeyboard() {
       
        idTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        passwordCheckTextField.resignFirstResponder()
        contentTextView.resignFirstResponder()
        
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
     
        hideKeyboard()
        
        return true
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        hideKeyboard()
    
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    
    }
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        if passwordTextField.text == passwordCheckTextField.text {
            dismiss(animated: true, completion: nil)
        }
        else {
            print("check password")
        }
    }
    
    @IBAction func didTapBackgroundView(_ sender: UITapGestureRecognizer) {
        hideKeyboard()
    }

    //MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
        
    }
    
}

