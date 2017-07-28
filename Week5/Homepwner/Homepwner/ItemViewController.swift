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
    var imageStore: ImageStore!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 65
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowItem" {
            
            if let row = tableView.indexPathForSelectedRow?.row {
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        }
    }

}

//MARK: Actions

extension ItemViewController {
    
    @IBAction func addNewItem(sender: AnyObject) {
        //        let lastRow = tableView.numberOfRows(inSection: 0)
        //        let indexPath = IndexPath(row: lastRow, section: 0)
        //
        //        tableView.insertRows(at: [indexPath], with: .automatic)
        
        // 새 물품을 만들고 저장소에 추가
        let newItem = itemStore.createItem()
        
        // 배열 안에서 이 항목의 위치를 계산
        if let index = itemStore.allItems.index(of: newItem) {
            let indexPath = IndexPath(row: index, section: 0)
            
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
}

//MARK: UITableViewDelegate

extension ItemViewController {
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        itemStore.moveItemAtIndex(from: sourceIndexPath.row, to: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if case .delete = editingStyle {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)"
            let message = "Are you sure you wanna delete this item?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "delete",
                                             style: .destructive,
                                             handler: { (action) -> Void in
                                                self.itemStore.removeItem(item: item)
                                                
                                                self.imageStore.deleteImageForKey(key: item.itemKey)
                                                
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 기본 모양을 가진 UITableViewCell 인스턴스를 만든다.
        //        let cell = UITableViewCell(style: .value1, reuseIdentifier: "UITableViewCell")
        
        // 재사용 셀이나 새로운 셀을 얻는다
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        let item = itemStore.allItems[indexPath.row]
        
        cell.updateLabels()
        cell.updateColor(item: item)
        
        //        cell.textLabel?.text = item.name
        //        cell.detailTextLabel?.text = "$ \(item.valueInDollars)"
        
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
}

