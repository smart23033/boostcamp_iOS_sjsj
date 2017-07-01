//
//  ViewController.swift
//  Quiz
//
//  Created by 김성준 on 2017. 7. 1..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    let questions : [String] = ["From what is cognac made?",
                                "What is 7+7?",
                                "What is the capital of Vermont?"]
    let answers : [String] = ["Grapes",
                              "14",
                              "Montpelier"]
    var currentQuestionIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        questionLabel.text = questions[currentQuestionIndex]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showNextQuestion(_ sender: Any) {
        currentQuestionIndex += 1
        if currentQuestionIndex == questions.count {
            currentQuestionIndex = 0
        }
        
        let question : String = questions[currentQuestionIndex]
        questionLabel.text = question
        answerLabel.text = "???"
    }
    
    @IBAction func showAnswer(_ sender: Any) {
        let answer : String = answers[currentQuestionIndex]
        answerLabel.text = answer
    }
    


}

