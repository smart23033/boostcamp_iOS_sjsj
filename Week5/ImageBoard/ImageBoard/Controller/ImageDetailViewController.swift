//
//  ImageDetailViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 8. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Properties

class ImageDetailViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView! 
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.text = article.author_nickname
        }
    }
    @IBOutlet weak var dateLabel: UILabel! {
        didSet {
            dateLabel.text = article.created_at.getDateStringFromUTC()
        }
    }
    @IBOutlet weak var textView: UITextView! {
        didSet {
            textView.text = article.image_desc
        }
    }
    
    var user: User!
    var article: Article!
    
}

//MARK: Life Cycle

extension ImageDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = article.image_title
        
        if self.user._id != self.article.author {
            self.navigationItem.rightBarButtonItems = nil
        }
        
        NetworkManager.shared.fetchImage(from: article) {
            (result) in
            OperationQueue.main.addOperation {
                
                self.imageView.image = self.article.image
                
            }
        }
        
    }
}

//MARK: Actions

extension ImageDetailViewController {
    
    @IBAction func touchUpTrashButton(_ sender: UIBarButtonItem) {
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
    
    @IBAction func touchUpEditButton(_ sender: UIBarButtonItem) {
    }

    @IBAction func didTapNameLabel(_ sender: UITapGestureRecognizer) {
    }
}
