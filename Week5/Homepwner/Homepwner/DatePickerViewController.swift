//
//  DatePickerViewController.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class DatePickerViewContrller: UIViewController {
    
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item! {
        didSet {
            navigationItem.title = item.name
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        datePicker.date = item.dateCreated as Date
               
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        item.dateCreated = datePicker.date as NSDate
    }
}
