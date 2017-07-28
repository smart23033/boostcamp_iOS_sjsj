//
//  Item.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 14..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: NSDate
    let itemKey: String
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as! String
        serialNumber = aDecoder.decodeObject(forKey: "serialNumber") as? String
        itemKey = aDecoder.decodeObject(forKey: "itemKey") as! String
        dateCreated = aDecoder.decodeObject(forKey: "dateCreated") as! NSDate
        valueInDollars = aDecoder.decodeInteger(forKey: "valueInDollars")
        
        super.init()
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(dateCreated, forKey: "dateCreated")
        aCoder.encode(itemKey, forKey: "itemKey")
        aCoder.encode(serialNumber, forKey: "serialNumber")
        aCoder.encode(valueInDollars, forKey: "valueInDollars")
    }
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = NSDate()
        self.itemKey = NSUUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy","Rusty","Shiny"]
            let nouns = ["Bear","Spork","Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = NSUUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName, serialNumber: randomSerialNumber, valueInDollars: randomValue)
            
        }
        else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
}
