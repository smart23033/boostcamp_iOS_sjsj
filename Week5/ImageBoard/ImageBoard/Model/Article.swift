//
//  Post.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 31..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class Article: Codable {
    
    let author: String
    let author_nickname: String?
    let created_at: Date
    let thumb_image_url: String
    let image_url: String?
    let image_title: String?
    let image_desc: String?
    let _id: String
    let __v: Int
    
    var thumbImage: UIImage?
    var image: UIImage?
    
    private enum CodingKeys : String, CodingKey {
        case author, author_nickname, created_at, thumb_image_url, image_url, image_title, image_desc, _id, __v
    }
    
    init(author: String = "", author_nickname: String = "", created_at: Int, thumb_image_url: String, image_url: String, image_title: String, image_desc: String = "", _id: String, __v: Int = 0) {
        self._id = _id
        self.created_at = Date(timeIntervalSince1970: TimeInterval(created_at))
        self.thumb_image_url = thumb_image_url
        self.image_url = image_url
        self.author_nickname = author_nickname
        self.author = author
        self.image_desc = image_desc
        self.image_title = image_title
        self.__v = __v
    }
    
}

extension Article: Equatable {
    static func == (lhs: Article, rhs: Article) -> Bool {
        return lhs._id == rhs._id
    }
}
