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
            user.date = "(" + splitedUserData[2] + splitedUserData[3] + ")"
            
            users.append(user)
            
        }
        
        users.sort { $0.record! < $1.record! }
        
    }
    
    // MARK: Actions
    
    @IBAction func didTapCancelButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: UITableViewDelegate

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath) as! RecordCell
        
        cell.nameLabel.text = "\(String(describing: users[indexPath.row].name!))     \(String(describing: users[indexPath.row].date!))"
        cell.recordLabel.text = users[indexPath.row].record
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
}
