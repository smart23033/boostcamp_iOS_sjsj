//
//  ViewController.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
        animateTitleTransitions()
    }
    
    func animateTitleTransitions() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat,.autoreverse], animations: { 
             self.titleLabel.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: { _ in 
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
}

