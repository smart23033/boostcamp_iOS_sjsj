//
//  MyButton.swift
//  MyButton
//
//  Created by 김성준 on 2017. 7. 16..
//  Copyright © 2017년 김성준. All rights reserved.


import UIKit

class MyButton: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var view: UIView!
    
    var isSelected: Bool = false {
        didSet {
            if isSelected == true {
                titleLabel.text = "selected"
                titleLabel.textColor = UIColor.green
            }
            else {
                titleLabel.text = "normal"
                titleLabel.textColor = UIColor.yellow
                
            }
        }
    }
    
    var isHighlighted: Bool = false {
        didSet {
            if isHighlighted == true, isSelected == false {
                titleLabel.text = "highlighted1"
                titleLabel.textColor = UIColor.white
            }
            else if isHighlighted == true, isSelected == true {
                titleLabel.text = "highlighted2"
                titleLabel.textColor = UIColor.red
            }
            else if isHighlighted == false, isSelected == false {
                titleLabel.text = "normal"
                titleLabel.textColor = UIColor.yellow
            }
            else if isHighlighted == false, isSelected == true {
                titleLabel.text = "selected"
                titleLabel.textColor = UIColor.green
            }
        }
    }
    
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
        //        print(#function)
        
        guard view.isUserInteractionEnabled == true else {
            return
        }
        
        isHighlighted = true
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        print(#function)
        
        guard view.isUserInteractionEnabled == true else {
            return
        }
        
        let touch = touches.first
        
        let touchLocation = touch?.location(in: view)
        
        guard self.bounds.contains(touchLocation!) else {
            isHighlighted = false
            return
        }
        
        isHighlighted = false
        didTapButton()
        
    }
    
    // MARK: Functions
    
    func didTapButton() {
        print("button tapped")
        isSelected = !isSelected
    }
    
    func didToggleButton() {
        if view.isUserInteractionEnabled == true {
            view.isUserInteractionEnabled = false
            view.alpha = 0.5
            view.backgroundColor = UIColor.gray
        }
        else if view.isUserInteractionEnabled == false {
            view.isUserInteractionEnabled = true
            view.alpha = 1.0
            view.backgroundColor = UIColor.black
        }
        
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents = .touchUpInside) {
        
    }
    
}
