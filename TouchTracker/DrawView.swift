//
//  DrawView.swift
//  TouchTracker
//
//  Created by Mischa Beumer on 3/21/17.
//  Copyright © 2017 msbbeumer. All rights reserved.
//

import UIKit

class DrawView: UIView, UIGestureRecognizerDelegate {
  // MARK: - Properties
  var currentLine = [Line]()
  var currentLines = [NSValue:[Line]]()
  var finishedLines = [[Line]]()
  var selectedLineArrayIndex: Int? {
    didSet {
      if selectedLineArrayIndex == nil {
        let menu = UIMenuController.shared
        menu.setMenuVisible(false, animated: true)
        moveRecognizer.cancelsTouchesInView = false
      }
    }
  }
  var moveRecognizer: UIPanGestureRecognizer!
  
  override var canBecomeFirstResponder: Bool {
    return true
  }
  
  var multiColorIsActive = true
  var selectedLineColor = UIColor.blue
  
  //MARK: - IBOutlets and IBActions for the ColorPanel
  @IBOutlet var colorPanel: UIView!

  @IBAction func redButton(_ sender: UIButton) {
    multiColorIsActive = false
    selectedLineColor = UIColor.red
  }
  @IBAction func orangeButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.orange
  }
  @IBAction func yellowButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.yellow
  }
  @IBAction func greenButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.green
  }
  @IBAction func blueButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.blue
  }
  @IBAction func purpleButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.purple
  }
  @IBAction func magentaButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.magenta
  }
  @IBAction func cyanButton(_ sender: Any) {
    multiColorIsActive = false
    selectedLineColor = UIColor.cyan
  }
  @IBAction func multiColorButton(_ sender: Any) {
    multiColorIsActive = true
  }
  
  
  // MARK: - @IBInspectables
  @IBInspectable var lineThickness: CGFloat = 6 {
    didSet {
      setNeedsDisplay()
    }
  }
  
  // MARK: - Gesture recognition
  // Set up the gesture recognizers
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.doubleTap(_:)))
    doubleTapRecognizer.numberOfTapsRequired = 2
    doubleTapRecognizer.delaysTouchesBegan = true
    addGestureRecognizer(doubleTapRecognizer)
    
    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
    tapRecognizer.numberOfTapsRequired = 1
    tapRecognizer.delaysTouchesBegan = true
    tapRecognizer.require(toFail: doubleTapRecognizer)
    addGestureRecognizer(tapRecognizer)
    
    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(DrawView.longPress(_:)))
    addGestureRecognizer(longPressRecognizer)
    
    moveRecognizer = UIPanGestureRecognizer(target: self, action: #selector(DrawView.moveLine(_:)))
    moveRecognizer.delegate = self
    moveRecognizer.cancelsTouchesInView = false
    addGestureRecognizer(moveRecognizer)
    
    let twoFingerSwipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(DrawView.threeFingerSwipe(_:)))
    twoFingerSwipeRecognizer.numberOfTouchesRequired = 2
    twoFingerSwipeRecognizer.direction = .up
    twoFingerSwipeRecognizer.delaysTouchesBegan = true
    addGestureRecognizer(twoFingerSwipeRecognizer)
    
  }
  // Implement the Three Finger Swipe action
  func threeFingerSwipe(_ gestureRecognizer: UISwipeGestureRecognizer) {
    colorPanel.isHidden = false
  }
  
  // Implement the Double Tap action
  func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
    print("Recognized a double tap")
    
    selectedLineArrayIndex = nil
    currentLine.removeAll()
    currentLines.removeAll()
    finishedLines.removeAll()
    
    setNeedsDisplay()
  }
  
  // Implement the Tap action
  func tap(_ gestureRecognizer: UIGestureRecognizer) {
    print("Recognized a tap")
    
    colorPanel.isHidden = true
    
    let point = gestureRecognizer.location(in: self)
    selectedLineArrayIndex = indexOfLine(at: point)
    
    let menu = UIMenuController.shared
    
    if selectedLineArrayIndex != nil {
      becomeFirstResponder()
      
      // Disable drawing
      moveRecognizer.cancelsTouchesInView = true
      
      let deleteItem = UIMenuItem(title: "Delete", action: #selector(DrawView.deleteLine(_:)))
      menu.menuItems = [deleteItem]
      
      let startLineIndex = finishedLines[selectedLineArrayIndex!].startIndex
      let selectedLineArray = finishedLines[selectedLineArrayIndex!]
      
      let targetRect = CGRect(x: selectedLineArray[startLineIndex].begin.x, y: selectedLineArray[startLineIndex].begin.y, width: 2, height: 2)
      menu.setTargetRect(targetRect, in: self)
      menu.setMenuVisible(true, animated: true)
    } else {
      menu.setMenuVisible(false, animated: true)
    }
    
    setNeedsDisplay()
  }
  
  // Implement the Long Press action
  func longPress(_ gestureRecognizer: UIGestureRecognizer) {
    print("Recognized a long press")
    
    if gestureRecognizer.state == .began {
      let point = gestureRecognizer.location(in: self)
      selectedLineArrayIndex = indexOfLine(at: point)
      
      if selectedLineArrayIndex != nil {
        currentLines.removeAll()
      }
    } else if gestureRecognizer.state == .ended {
      selectedLineArrayIndex = nil
    }
    
    setNeedsDisplay()
  }
  
  // Implement the Pan Gesture Recognizer
  func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
    print("Recognized a pan")
    
    if let arrayIndex = selectedLineArrayIndex {
      if gestureRecognizer.state == .changed {
        let translation = gestureRecognizer.translation(in: self)
        for (index, var line) in finishedLines[arrayIndex].enumerated() {
          line.begin.x += translation.x
          line.begin.y += translation.y
          line.end.x += translation.x
          line.end.y += translation.y
          
          let newLine = Line(begin: line.begin, end: line.end, color: selectedLineColor)
          finishedLines[arrayIndex].remove(at: index)
          finishedLines[arrayIndex].insert(newLine, at: index)
          
          gestureRecognizer.setTranslation(CGPoint.zero, in: self)
          
        }
        
        let startLineMenuLocationArray = finishedLines[arrayIndex]
        let startLineMenuLocationIndex = startLineMenuLocationArray.startIndex
        UIMenuController.shared.setTargetRect(CGRect(x: startLineMenuLocationArray[startLineMenuLocationIndex].begin.x, y: startLineMenuLocationArray[startLineMenuLocationIndex].begin.y, width: 2, height: 2), in: self)
        setNeedsDisplay()
      }
    } else {
      return
    }
  }
  
  // Implement the deleteLine function
  func deleteLine(_ sender: UIMenuController) {
    if let index = selectedLineArrayIndex {
      finishedLines.remove(at: index)
      selectedLineArrayIndex = nil
      
      setNeedsDisplay()
    }
  }
  
  // Implement the gesture recognizer delegate method to allow simultaneous gesture recognition
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  // Function to return the index of a line in the finished lines array
  func indexOfLine(at point: CGPoint) -> Int? {
    for (index, lineArray) in finishedLines.enumerated() {
      let begin = lineArray.first?.begin
      let end = lineArray.last?.end
      
      // Check  a few points on the line
      for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
        let x = (begin?.x)! + (((end?.x)! - (begin?.x)!) * t)
        let y = (begin?.y)! + (((end?.y)! - (begin?.y)!) * t)
        
        // If the tapped point is within 20 points, return this line
        if  hypot(x - point.x, y - point.y) < 20.0 {
          return index
        }
      }
    }
    
    // If nothing is close enough to the tapped point, then no line is selected
    return nil
  }
  
  // MARK: - Drawing methods
  func stroke(_ line: Line) {
    let path = UIBezierPath()
    path.lineWidth = lineThickness
    path.lineCapStyle = .round
    
    path.move(to: line.begin)
    path.addLine(to: line.end)
    path.stroke()
  }
  
  override func draw(_ rect: CGRect) {
    
    // Draw lines
    for lineArray in finishedLines {
      for line in lineArray {
        line.color.setStroke()
        stroke(line)
      }
    }
    
    for(_, lineArray) in currentLines {
      for line in lineArray {
        line.color.setStroke()
        stroke(line)
      }
    }
    
    // Color the selected line gray
    if let index = selectedLineArrayIndex {
      UIColor.lightGray.setStroke()
      let selectedLineArray = finishedLines[index]
      for line in selectedLineArray {
        stroke(line)
      }
    }
  }
  
  // MARK: - Touch events
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Log statement to see the order of events
    print(#function)
    
    for touch in touches {
      let location = touch.location(in: self)
      
      var newLine = Line(begin: location, end: location, color: UIColor.blue)
      if multiColorIsActive {
        newLine.color =  UIColor(hue: newLine.hueCode, saturation: 1, brightness: 1, alpha: 1)
      } else {
        newLine.color = selectedLineColor
      }
      currentLine.append(newLine)
      let key = NSValue(nonretainedObject: touch)
      currentLines[key] = currentLine
    }
    setNeedsDisplay()
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Log statement to see the order of events
    print(#function)
    
    for touch in touches {
      let key = NSValue(nonretainedObject: touch)
      
      if var lineArray = currentLines[key] {
        let lastLineIndex = (lineArray.endIndex) - 1
        var newLine = Line(begin: lineArray[lastLineIndex].end, end: touch.location(in: self), color: UIColor.blue)
        if multiColorIsActive {
          newLine.color =  UIColor(hue: newLine.hueCode, saturation: 1, brightness: 1, alpha: 1)
        } else {
          newLine.color = selectedLineColor
        }
        currentLine.append(newLine)
        currentLines[key] = currentLine
      }
    }
    setNeedsDisplay()
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Log statement to see the order of events
    
    for touch in touches {
      let key = NSValue(nonretainedObject: touch)
      if var lineArray = currentLines[key] {
        let lastLineIndex = (currentLines[key]?.endIndex)! - 1
        var newLine = Line(begin: lineArray[lastLineIndex].end, end: touch.location(in: self), color: UIColor.blue)
        if multiColorIsActive {
          newLine.color =  UIColor(hue: newLine.hueCode, saturation: 1, brightness: 1, alpha: 1)
        } else {
          newLine.color = selectedLineColor
        }
        lineArray.append(newLine)
        
        
        finishedLines.append(lineArray)
        currentLines.removeValue(forKey: key)
        currentLine.removeAll()
      }
    }
    setNeedsDisplay()
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    // Log statement to see the order of events
    print(#function)
    
    currentLines.removeAll()
    currentLine.removeAll()
    
    setNeedsDisplay()
  }
}
