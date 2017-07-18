//
//  EnableButton.swift
//  MyButton
//
//  Created by 김성준 on 2017. 7. 18..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ToggleButton: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var view: UIView!
    
    var isEnabled: Bool = true
    var notificationCenter = NotificationCenter.default
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    func setUp() {
        Bundle.main.loadNibNamed("ToggleButton", owner: self, options: nil)
        
        self.addSubview(view)
        
    }
    
    // MARK: Touch Events
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isEnabled = !isEnabled
    }
    
    @IBAction func didTapButton(_ sender: UITapGestureRecognizer) {
        if isEnabled == true {
            titleLabel.text = "Disable button"
            notificationCenter.post(name: NSNotification.Name(rawValue: "toggleButton"), object: nil)
        }
        else {
            titleLabel.text = "Enable button"
            notificationCenter.post(name: NSNotification.Name(rawValue: "toggleButton"), object: nil)
        }
    }
    
}
