//
//  DrawView.swift
//  TouchTracker
//
//  Created by 김성준 on 2017. 7. 8..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
//    var currentLine: Line?
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func strokeLine(line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = CGLineCap.round
        
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    
    override func draw(_ rect: CGRect) {
        // 완성된 선은 검은색
        finishedLineColor.setStroke()
        for line in finishedLines {
            strokeLine(line: line)
        }
        
//        if let line = currentLine {
            // 현재 그리는 중인 선은 빨간색
//            UIColor.red.setStroke()
//            strokeLine(line: line)
//        }
        
        // 현재 그리는 중인 선은 빨간색
        currentLineColor.setStroke()
        for (_, line) in currentLines {
            strokeLine(line: line)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
        // view의 좌표계에서 터치의 위치를 얻는다
//        let location = touch.location(in: self)
//        
//        currentLine = Line(begin: location, end: location)

        print(#function)
        
        for touch in touches {
            let location = touch.location(in: self)
            
            let newLine = Line(begin: location, end: location)
            
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let touch = touches.first!
//        let location = touch.location(in: self)
//        
//        currentLine?.end = location

        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if var line = currentLine {
//            let touch = touches.first!
//            let location = touch.location(in: self)
//            line.end = location
//            
//            finishedLines.append(line)
//        }
//        currentLine = nil

        print(#function)
        
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        print(#function)
        
        currentLines.removeAll()
        
        setNeedsDisplay()
    }
}
