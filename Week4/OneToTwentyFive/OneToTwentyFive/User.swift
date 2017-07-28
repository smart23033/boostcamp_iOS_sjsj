//
//  User.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 24..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class User: NSObject {
    var name: String?
    var record: String?
    var date: String?
    
    override var description: String {
        return name! + " " + record! + " " + "\(date!)"
    }
    
    init(name: String = "", record: String = "") {
        self.name = name
        self.record = record
        self.date = "\(Date())"
    }
    
}
