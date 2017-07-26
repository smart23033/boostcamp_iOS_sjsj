//
//  HistoryTableViewController.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)

        
    }
    
    // MARK: Actions
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapResetButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Really?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: .default, handler: { (UIAlertActionb) -> Void in
            Records.sharedInstance.records.removeAll()
            self.tableView.reloadData()

        })
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        let record = Records.sharedInstance.records.sorted{$0.record! < $1.record!}[indexPath.row]
        
        cell.nameLabel.text = "\(record.name!)   (\(record.date!)))"
        cell.recordLabel.text = "\(record.record!)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Records.sharedInstance.records.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let title = "Delete item"
            let message = "Are you sure you wanna delete this item?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: { (action) -> Void in
                                                let item = Records.sharedInstance.records[indexPath.row]
                                                Records.sharedInstance.removeItem(item: item)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
}

