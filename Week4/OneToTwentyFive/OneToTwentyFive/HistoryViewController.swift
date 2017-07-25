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
    
    var fileIOManager = IOManager()
    var data = Data()
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: UIApplication.shared.statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        
        data = fileIOManager.readFile(fileName: "record".appending("txt"))!
        
        var userDatas = String(data: data, encoding: String.Encoding.utf8)!.components(separatedBy: "\r\n")
        userDatas.popLast()
        
        for userData in userDatas {
            let user = User()
            
            var splitedUserData = userData.characters.split(separator: " ").map(String.init)
            
            user.name = splitedUserData[0]
            user.record = splitedUserData[1]
            user.date = splitedUserData[2] + " " + splitedUserData[3]
            
            users.append(user)
            
        }
        
        users.sort { $0.record! < $1.record! }
        
    }
    
    // MARK: Actions
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapResetButton(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Really?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "YES", style: .default, handler: { (UIAlertActionb) -> Void in
            self.fileIOManager.clearFile(fileName: "record".appending("txt"))
            self.users.removeAll()
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
        
        cell.nameLabel.text = "\(String(describing: users[indexPath.row].name!))   (\(String(describing: users[indexPath.row].date!)))"
        cell.recordLabel.text = users[indexPath.row].record
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let title = "Delete \(users[indexPath.row].name!)"
            let message = "Are you sure you wanna delete this item?"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive,
                                             handler: { (action) -> Void in
                                                //해당 유저를 파일에서 삭제하는 부분 추가해라
                                                self.fileIOManager.removeItem(fileName: "record".appending("txt"), user: self.users[indexPath.row])
                                                self.users.remove(at: indexPath.row)
                                                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            })
            
            alertController.addAction(deleteAction)
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
}
