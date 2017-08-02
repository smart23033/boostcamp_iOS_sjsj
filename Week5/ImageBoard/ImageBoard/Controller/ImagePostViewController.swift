//
//  ImagePostViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 8. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Properties

class ImagePostViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField! {
        didSet {
            nameField.isHidden = true
        }
    }
    @IBOutlet weak var dateField: UITextField! {
        didSet {
            dateField.isHidden = true
        }
    }
    
    let imagePicker = UIImagePickerController()
    
    var imageTitle: String!
    var imageDescription: String? = ""
    var imageData: UIImage!
    
    var user: User!
    var article: Article!
    
}

//MARK: Life Cycle

extension ImagePostViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.allowsEditing = true
        
    }
    
}

//MARK: Actions

extension ImagePostViewController {
    
    @IBAction func touchUpDoneButton(_ sender: UIBarButtonItem) {
        imageTitle = titleField.text
        imageDescription = textView.text
        imageData = imageView.image
        
        NetworkManager.shared.fetchUploadInfo(title: imageTitle, desc: imageDescription!, image: imageData) {
            (result) -> Void in
            
            switch result {
            case let .success(articles):
                print("upload success")
            case let .failure(error):
                print("upload fail")
                print(error)
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapImageView(_ sender: UITapGestureRecognizer) {
        self.endEditing()
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: Functions

extension ImagePostViewController {
    func endEditing() {
        
        self.view.subviews.forEach {
            if $0.isFirstResponder, $0.responds(to: #selector(UIView.self.endEditing)) {
                $0.endEditing(true)
            }
        }
    }
}

//MARK: UIImagePickerControllerDelegate

extension ImagePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageView.image = image
        } else if let image: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.image = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
