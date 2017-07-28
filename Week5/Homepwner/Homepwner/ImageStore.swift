//
//  ImageStore.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 28..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    
    let cache = NSCache<AnyObject, UIImage>()
    
    func setImage(image: UIImage, forKey key:String) {
        cache.setObject(image, forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        
        if let data = UIImagePNGRepresentation(image) {
            do {
                try data.write(to: imageURL)
            }
            catch {
                print("fail to write iamge at \(imageURL)")
            }
        }
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = cache.object(forKey: key as AnyObject) {
            return existingImage
        }
        
        let imageURL = imageURLForKey(key: key)
        guard let imageFromDisk = UIImage(contentsOfFile: imageURL.path) else {
            return nil
        }
        
        cache.setObject(imageFromDisk, forKey: key as AnyObject)
        
        return imageFromDisk
        
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObject(forKey: key as AnyObject)
        
        let imageURL = imageURLForKey(key: key)
        do {
            try FileManager.default.removeItem(at: imageURL)
        }
        catch {
            print("failt to remove image at \(imageURL)")
        }
    }
    
    func imageURLForKey(key: String) -> URL {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        return documentDirectory.appendingPathComponent(key)
    }
}
