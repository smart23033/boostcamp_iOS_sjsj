//
//  Extensions.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 8. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import Foundation

//MARK: NSMutableData

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension Date {
    func getDateStringFromUTC() -> String {
        let date = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd, MMMM yyyy HH:mm:a"
        dateFormatter.timeZone =  TimeZone(identifier: "UTC")
       
        
        return dateFormatter.string(from: date)
    }
}
