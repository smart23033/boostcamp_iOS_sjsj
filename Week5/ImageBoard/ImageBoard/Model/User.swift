//
//  User.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 29..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class User: Codable {
    
    let nickname: String
    let password: String
    let email: String
    let _id: String
    let __v: Int
    
    init(email: String, password: String, nickname: String = "", _id: String = "", __v: Int = 0) {
        self.email = email
        self.nickname = nickname
        self.password = password
        self._id = _id
        self.__v = __v
    }
 
}

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs._id == rhs._id
    }
}
