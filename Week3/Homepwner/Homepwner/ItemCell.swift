//
//  ItemCell.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 14..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serialNumberLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func updateLabels() {
        let bodyFont = UIFont.preferredFont(forTextStyle: .body)
        nameLabel.font = bodyFont
        valueLabel.font = bodyFont
        
        let caption1Font = UIFont.preferredFont(forTextStyle: .caption1)
        serialNumberLabel.font = caption1Font
        
    }
    
    func updateColor(item: Item) {
        if item.valueInDollars >= 50 {
            self.backgroundColor = UIColor(red: 1, green: 0.67, blue: 0.67, alpha: 0.5)
        }
        else {
            self.backgroundColor = UIColor(red: 0.75, green: 0.98, blue: 0.89, alpha: 0.5)
        }
    }
}
