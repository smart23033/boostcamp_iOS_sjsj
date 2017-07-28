//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by 김성준 on 2017. 7. 28..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    
    var store: PhotoStore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo: photo) { (result) -> Void in
            switch result {
            case let .success(image):
                OperationQueue.main.addOperation({
                    self.imageView.image = image
                })
            case let .failure(error):
                print("error fetching image for photo: \(error)")
            }
        }
    }
}
