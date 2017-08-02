//
//  ImagePostViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 8. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Properties

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var titleField: UITextField! {
        didSet {
            titleField.isEnabled = false
            titleField.borderStyle = .none
        }
    }
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameField: UITextField! {
        didSet {
            nameField.isHidden = false
            nameField.borderStyle = .none
        }
    }
    @IBOutlet weak var dateField: UITextField! {
        didSet {
            dateField.isHidden = false
            dateField.borderStyle = .none
        }
    }
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    lazy var doneButton: UIBarButtonItem! = {
        return UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(touchUpDoneButton(_:)))
    }()
    lazy var deleteButton: UIBarButtonItem! = {
            return UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(touchUpDeleteButton(_:)))
        
    }()
    lazy var editButton: UIBarButtonItem! = {
            return UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchUpEditButton(_:)))
        
    }()
    
    let imagePicker = UIImagePickerController()
    
    var imageTitle: String!
    var imageDescription: String? = ""
    var imageData: UIImage!
    
    var user: User!
    var article: Article!
    
}

//MARK: Life Cycle

extension ImageDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if user != nil {
            self.navigationItem.leftBarButtonItem = nil
            self.imageView.isUserInteractionEnabled = false
         
            if self.user._id == self.article.author {
                self.navigationItem.rightBarButtonItems = [deleteButton,editButton]
            }
            
            NetworkManager.shared.fetchImage(from: article) {
                (result) in
                OperationQueue.main.addOperation {
                    
                    self.imageView.image = self.article.image
                    self.titleField.text = self.article.image_title
                    self.dateField.text = self.article.created_at.getDateStringFromUTC()
                    self.nameField.text = self.article.author_nickname
                    self.textView.text = self.article.image_desc
                
                }
            }
        }
        else {
            self.imageView.isUserInteractionEnabled = true
            
            dateField.isHidden = true
            nameField.isHidden = true
            titleField.isEnabled = true
            titleField.borderStyle = .roundedRect
            
            self.navigationItem.rightBarButtonItem = doneButton
            
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
        }
        
    }
    
}

//MARK: Actions

extension ImageDetailViewController {
    
    func touchUpEditButton(_ sender: UIBarButtonItem){
        
    }
    
    func touchUpDeleteButton(_ sender: UIBarButtonItem) {
        let alertControlelr = UIAlertController(title: "삭제", message: "정말 삭제하시겠습니까?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive, handler: {
            _ -> Void in
            NetworkManager.shared.fetchDeleteInfo(from: self.article){
                (result) -> Void in
                
                //               보류. article이 배열로 디코딩하기 때문에 에러남. 네트워크로부터 가져오는 건 배열아님
                //                switch result {
                //                case let .success(articles):
                //                    print("delete success")
                //                    print(articles)
                //                case let .failure(error):
                //                    print("delete fail")
                //                    print(error)
                //                }
                
            }
            self.navigationController?.popViewController(animated: true)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertControlelr.addAction(okAction)
        alertControlelr.addAction(cancelAction)
        
        present(alertControlelr, animated: true, completion: nil)
    }
    
    func touchUpDoneButton(_ sender: UIBarButtonItem) {
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
        print(#function)
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
}

//MARK: Functions

extension ImageDetailViewController {
    func endEditing() {
        
        self.view.subviews.forEach {
            if $0.isFirstResponder, $0.responds(to: #selector(UIView.self.endEditing)) {
                $0.endEditing(true)
            }
        }
    }
}

//MARK: UIImagePickerControllerDelegate

extension ImageDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
