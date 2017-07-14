//
//  ItemStore.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 14..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ItemStore {
//    var allItems = [Item]()
    var ItemsByValue = [[Item](),[Item]()]
   
//    func createItem() -> Item {
//        let newItem = Item(random: true)
//        
//        allItems.append(newItem)
//        
//        return newItem
//    }
    
    func createItem(byValue value: Int = 50) -> Item {
        let newItem = Item(random: true)
        
        if newItem.valueInDollars > value {
            ItemsByValue[0].append(newItem)
        }
        else {
            ItemsByValue[1].append(newItem)
        }
        
        return newItem
    }
    
    init() {
        for _ in 0..<20 {
//            createItem()
            createItem(byValue: 50)
        }
    }
    
}
