//
//  WebViewController.swift
//  WorldTrotter
//
//  Created by 김성준 on 2017. 7. 8..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func loadView() {
        
        webView = WKWebView()
        
        let myURL = URL(string: "https://www.bignerdranch.com")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("WebViewController loaded its view")
        
    }
    
}
