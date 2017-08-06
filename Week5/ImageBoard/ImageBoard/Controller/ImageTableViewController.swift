//
//  ImageTableViewController.swift
//  ImageBoard
//
//  Created by 김성준 on 2017. 7. 30..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

//MARK: Properties

class ImageTableViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User?
    var articles: [Article]!
    let refreshControl = UIRefreshControl()
    var isSorted: Bool = false
    
}

//MARK: Life Cycle

extension ImageTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if user != nil {
            tableView.delegate = self
            tableView.dataSource = self
            
            fetchBoardInfo()
            
        }
        else {
            print("user 정보가 없음. 로그인 뷰컨트롤러로 이동.")
            performSegue(withIdentifier: "Login", sender: nil)
        }
        
    }
}

//MARK: Actions

extension ImageTableViewController {
    
    @IBAction func touchUpSortButton(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "정렬", message: nil, preferredStyle: .actionSheet)
        let myArticleAction = UIAlertAction(title: "내 게시물만 보기", style: .default, handler: {
            _ -> Void in
            self.isSorted = true
            self.fetchMyBoardInfo()
        })
        let allArticlesAction = UIAlertAction(title: "전체 게시물 보기", style: .default, handler: {
            _ -> Void in
            self.isSorted = false
            self.fetchBoardInfo()
        })
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alertController.addAction(myArticleAction)
        alertController.addAction(allArticlesAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}

//MARK: Functions

extension ImageTableViewController {
    func refresh(_ refreshControl: UIRefreshControl) {
        switch isSorted {
        case true:
            fetchMyBoardInfo()
        case false:
            fetchBoardInfo()
        }
        refreshControl.endRefreshing()
    }
    
    func fetchBoardInfo() {
        NetworkManager.shared.fetchBoardInfo({ (result) in
            OperationQueue.main.addOperation {
                switch result {
                case let .success(articles):
                    self.articles = articles.reversed()
                    self.tableView.reloadData()
                case let .failure(error):
                    self.articles.removeAll()
                    print(error)
                }
            }
        })
    }
    
    func fetchMyBoardInfo() {
        NetworkManager.shared.fetchBoardInfo({ (result) in
            OperationQueue.main.addOperation {
                switch result {
                case let .success(articles):
                     self.articles = articles.filter({ (article) -> Bool in
                        if self.user?._id == article.author {
                            return true
                        }
                        else {
                            return false
                        }
                    }).reversed()
                    self.tableView.reloadData()
                case let .failure(error):
                    self.articles.removeAll()
                    print(error)
                }
            }
        })
    }
}

//MARK: Segues

extension ImageTableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Login" {
            let loginNavigationController = segue.destination as! UINavigationController
            let destinationVC = loginNavigationController.topViewController as! LoginViewController
            destinationVC.loginDelegate = self
        }
        else if segue.identifier == "Detail" {
            if let row = tableView.indexPathForSelectedRow?.row {
                let article = articles[row]
                let destinationVC = segue.destination as! ImageDetailViewController
                destinationVC.user = user
                destinationVC.article = article
            }
        }
    }
    
}

//MARK: UITableViewDelegate

extension ImageTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //테이블 뷰 리로드 되기전 article = nil 에 대한 방어..
        guard articles != nil else {
            return 1
        }
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let identifier = "ImageBoardTableCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! ImageTableViewCell
        
        //테이블 뷰 리로드 되기전 article = nil 에 대한 방어..
        guard articles != nil else {
            return cell
        }
        
        cell.updateLabels(articles[indexPath.row])
        
        NetworkManager.shared.fetchThumbImage(from: articles[indexPath.row]) {
            (result) -> Void in
            
            OperationQueue.main.addOperation {
                cell.updateThumbImage(self.articles[indexPath.row])
            }
        }
        
        return cell
    }
    
    //    이거 대신 세그를 연결해서 row에 따라 다른 article을 보내주게 하긴 함.
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //    }
    
}

//MARK: LoginDelegate

extension ImageTableViewController: LoginDelegate {
    func didLoginSuccess(user: User) {
        self.user = user
    }
}
