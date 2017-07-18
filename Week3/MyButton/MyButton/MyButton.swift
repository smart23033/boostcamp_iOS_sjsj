//
//  MyButton.swift
//  MyButton
//
//  Created by 김성준 on 2017. 7. 16..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class MyButton: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var isSelected: Bool = false
    var isHighlighted: Bool = false
    let notificationCenter = NotificationCenter.default
    
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
        Bundle.main.loadNibNamed("MyButton", owner: self, options: nil)
        
        self.addSubview(view)
        
        notificationCenter.addObserver(self, selector: #selector(didToggleButton), name: NSNotification.Name(rawValue: "toggleButton"), object: nil)
        
    }
    
    // MARK: Touch Events
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        if view.isUserInteractionEnabled == true {
            isHighlighted = true
            highlightMyView(highlight: isHighlighted)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
        
        if view.isUserInteractionEnabled == true {
            isHighlighted = false
            highlightMyView(highlight: isHighlighted)
        }
        
    }
    
    // MARK: Actions
    
    @IBAction func didTapButton(_ sender: UITapGestureRecognizer) {
        
        print("button tapped")
        
        if isSelected == false {
            titleLabel.text = "selected"
            titleLabel.textColor = UIColor.green
            isSelected = true
        }
        else if isSelected == true {
            titleLabel.text = "normal"
            titleLabel.textColor = UIColor.yellow
            isSelected = false
        }
    }
    
    // MARK: Functions
    
    func didToggleButton() {
        if view.isUserInteractionEnabled == true {
            view.isUserInteractionEnabled = false
            view.alpha = 0.5
            view.backgroundColor = UIColor.gray
        }
        else {
            view.isUserInteractionEnabled = true
            view.alpha = 1.0
            view.backgroundColor = UIColor.black
        }
    }
    
    func highlightMyView(highlight: Bool) {
        
        if highlight == true, isSelected == false {
            titleLabel.text = "highlighted1"
            titleLabel.textColor = UIColor.white
        }
        else if highlight == true, isSelected == true {
            titleLabel.text = "highlighted2"
            titleLabel.textColor = UIColor.red
        }
        else if highlight == false, isSelected == false {
            titleLabel.text = "normal"
            titleLabel.textColor = UIColor.yellow
        }
        else if highlight == false, isSelected == true {
            titleLabel.text = "selected"
            titleLabel.textColor = UIColor.green
        }
    }
    
}
