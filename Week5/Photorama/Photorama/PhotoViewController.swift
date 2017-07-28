//
//  ViewController.swift
//  Photorama
//
//  Created by 김성준 on 2017. 7. 28..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        store.fetchRecentPhotos(){
            (PhotosResult) -> Void in
            
            switch PhotosResult {
            case let .success(photos):
                print("successfully found \(photos.count) recent photos.")
        
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(photo: firstPhoto, completion: {
                        (imageResult) -> Void in
                        
                        switch imageResult {
                        case let .success(image):
                            OperationQueue.main.addOperation({ 
                                self.imageView.image = image
                            })
                        case let .failure(error):
                            print("error downloading image: \(error)")
                        }
                        
                    })
                }
                
            
            case let .failure(error):
                print("error fetching recent photos : \(error)")
            }
        }
        
    }
}

