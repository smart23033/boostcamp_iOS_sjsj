//
//  GameViewController.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topRecordLabel: UILabel!
    
    var timer = Timer()
    var startTime = 0.0
    
    var count = 1
    let maximumCellNumber = 25
    var numberInCell: [Int] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25]
    
    var fileIOManager = IOManager()
    var data = Data()
    var users: [User] = []
    
    var numberOfItemsPerRow = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        users = [User]()
        timerLabel.text = "00:00:00"

        guard fileIOManager.readFile(fileName: "record".appending("txt"))?.isEmpty == false else {
            return
        }
        
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
        
        guard users.isEmpty == false else {
            topRecordLabel.text = "- --:--:--"
            return
        }
        
        topRecordLabel.text = "\(users[0].name!) \(users[0].record!)"
    }
    
    // MARK: Actions
    
    @IBAction func didTapPlayButton(_ sender: UIButton) {
        playButton.isHidden = true
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        startTime = NSDate.timeIntervalSinceReferenceDate
        
        for i in 1...25 {
            self.numberInCell.append(i)
        }
        collectionView.reloadData()
    }
    
    @IBAction func didTapHomeButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Functions
    
    func updateTimer() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(elapsedTime)
        elapsedTime -= TimeInterval(seconds)
        
        let milliseconds = UInt8(elapsedTime * 100)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", milliseconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        print(#function)
    }
    
}


// MARK: UICollectionViewDelegate

extension GameViewController:
    UICollectionViewDataSource,
    UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! NumberCell
        
        if cell.numberLabel.text! == String(self.count) {
            cell.isHidden = true
            self.count += 1
        }
        else {
            startTime -= 1.5
        }
        
        if self.count > maximumCellNumber {
            timer.invalidate()
            playButton.isHidden = false
            
            let alertController = UIAlertController(title: "Clear!", message: "Enter your name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: { alert -> Void in
                let nameTextField = alertController.textFields![0] as UITextField
                if nameTextField.text != "" {
                    let user = User(name: nameTextField.text!, record: self.timerLabel.text!)
                    self.fileIOManager.writeFile(fileName: "record".appending("txt"), result: user.description + "\r\n")
            
                    guard self.users.isEmpty == false else {
                        self.users.append(user)
                        self.topRecordLabel.text = "\(nameTextField.text!) \(self.timerLabel.text!)"
                        return
                    }
                    
                    if user.record! < self.users[0].record! {
                        self.topRecordLabel.text = "\(user.name!) \(user.record!)"
                    }
                    
                } else {
                    let errorAlert = UIAlertController(title: "Error", message: "Please input your name", preferredStyle: .alert)
                    errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {
                        alert -> Void in
                        self.present(alertController, animated: true, completion: nil)
                    }))
                    self.present(errorAlert, animated: true, completion: nil)
                }
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Input your name"
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return maximumCellNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "NumberCell"
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! NumberCell
        
        cell.numberLabel.alpha = 0
        cell.isHidden = false
        
        UIView.animate(withDuration: 0.5) {
            
            cell.numberLabel.alpha = 1
            
            let randomIndex = Int(arc4random_uniform(UInt32(self.numberInCell.count)))
            
            cell.numberLabel.text = "\(self.numberInCell[randomIndex])"
            self.numberInCell.remove(at: randomIndex)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfItemsPerRow - 1))
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(numberOfItemsPerRow))
        
        return CGSize(width: size, height: size)
        
    }
    
}
