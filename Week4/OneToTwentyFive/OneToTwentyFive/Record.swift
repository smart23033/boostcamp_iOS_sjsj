//
//  User.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 24..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class Record: NSObject,NSCoding {
    var name: String?
    var record: String?
    var date: String?
    
    init(name: String = "", record: String = "") {
        self.name = name
        self.record = record
        self.date = "\(Date())"
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        record = aDecoder.decodeObject(forKey: "record") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(record, forKey: "record")
        aCoder.encode(date, forKey: "date")
    }
    
    override var description: String {
        return name! + " " + record! + " " + "\(date!)"
    }
    
}

class Records: NSObject, NSCoding {
    static var sharedInstance = Records()
    var records = [Record]()
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        records = aDecoder.decodeObject(forKey: "records") as! [Record]
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(records, forKey:"records")
    }
    
    func removeItem(item: Record) {
        if let index = records.index(of: item) {
            records.remove(at: index)
        }
    }
    
}
