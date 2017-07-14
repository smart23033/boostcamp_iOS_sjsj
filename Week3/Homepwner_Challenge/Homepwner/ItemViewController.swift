//
//  ViewController.swift
//  Homepwner
//
//  Created by 김성준 on 2017. 7. 14..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ItemViewController: UITableViewController {
    
    var itemStore: ItemStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: statusBarHeight, right: 0)
        
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return itemStore.ItemsByValue.count + 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        var headerText = ""
        
        switch section {
        case 0:
            headerText = "over 50 dollars"
        case 1:
            headerText = "under 50 dollars"
        default: break
        }
        
        return headerText
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0,1:
            return itemStore.ItemsByValue[section].count
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 기본 모양을 가진 UITableViewCell 인스턴스를 만든다.
        //        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // 재사용 셀이나 새로운 셀을 얻는다
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        if indexPath.section == 2 {
            cell.textLabel?.text = "no more items"
            cell.detailTextLabel?.text = ""
            cell.backgroundColor = UIColor(red: 1.0, green: 0.53, blue: 0.53, alpha: 1)
            
            tableView.rowHeight = 44
            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 17)
            cell.detailTextLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 17)
        
        }
        else {
            let item = itemStore.ItemsByValue[indexPath.section][indexPath.row]
            
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "$ \(item.valueInDollars)"
            cell.backgroundColor = UIColor.white
            
            tableView.rowHeight = 60
            cell.textLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 20)
            cell.detailTextLabel?.font = UIFont(name: (cell.textLabel?.font.fontName)!, size: 20)
        
        }
        return cell
    }
    
}

