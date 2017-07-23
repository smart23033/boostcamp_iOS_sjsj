//
//  ViewController.swift
//  Week3Quiz
//
//  Created by JUN LEE on 2017. 7. 19..
//  Copyright © 2017년 LEEJUN. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // MARK: Properties
    
    var membersInSection: [(String, [String])] = []
    var membersOfSameFirstAlphabet: [String] = []
    // 연락처 이름의 첫번째 알파벳 배열
    var memberIndexs: [String] = []
    // 연락처 이름이 members에 저장됨
    var members: [String] = [] {
        
        didSet {
            for member in members {
                if let firstAlphabet = member.characters.first {
                    memberIndexs.append("\(firstAlphabet)")
                }
            }
            
            memberIndexs = Array(Set(memberIndexs))
            memberIndexs.sort(by: <)
            
            for memberIndex in memberIndexs {
                membersOfSameFirstAlphabet = []
                for member in members {
                    if let firstAlphabet = member.characters.first {
                        if memberIndex == "\(firstAlphabet)" {
                            membersOfSameFirstAlphabet.append(member)
                        }
                    }
                }
                membersInSection.append((memberIndex , membersOfSameFirstAlphabet))
            }
        }
    }
    
    
    // MARK: override
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 번들 내에 있는 연락처 정보를 가져옴
        guard let url = Bundle.main.url(forResource: "MemberList", withExtension: "rtf") else { return }
        let attString = try? NSAttributedString(url: url, options: [:], documentAttributes: nil)
        guard let names = attString?.string.components(separatedBy: "\n") else { return }
        
        self.members = names
        
    }
    
    // 연락처 이름을 각 셀에 저장합니다
    
    // 연락처 이름의 첫번째 알파벳들을 섹션으로 나눠줘야 합니다.
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return membersInSection.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return membersInSection[section].0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        
        cell.textLabel?.text = membersInSection[indexPath.section].1[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return membersInSection[section].1.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return memberIndexs
    }
    
    
}
