//
//  ImageTableViewCell.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 30..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func updateLabels(_ article: Article) {
        titleLabel.text = article.image_title
        userLabel.text = article.author_nickname
        dateLabel.text = article.created_at.getDateStringFromUTC()
    }
    
    func updateThumbImage(_ article: Article?) {
        if let imageToDisplay = article?.thumbImage {
            spinner.stopAnimating()
            spinner.isHidden = true
            photoImageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView?.image = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateThumbImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        updateThumbImage(nil)
    }
}
