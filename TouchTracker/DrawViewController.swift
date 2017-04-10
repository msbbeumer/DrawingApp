//
//  DrawViewController.swift
//  TouchTracker
//
//  Created by Mischa Beumer on 4/7/17.
//  Copyright © 2017 msbbeumer. All rights reserved.
//

import UIKit


class DrawViewController: UIViewController {
  
  @IBOutlet var colorPanel: UIView!
  @IBOutlet var drawView: DrawView!
  

  // MARK: - Color Panel Actions
  @IBAction func redButton(_ sender: UIButton) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.red
  }
  @IBAction func orangeButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.orange
  }
  @IBAction func yellowButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.yellow
  }
  @IBAction func greenButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.green
  }
  @IBAction func blueButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.blue
  }
  @IBAction func purpleButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.purple
  }
  @IBAction func magentaButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.magenta
  }
  @IBAction func cyanButton(_ sender: Any) {
    drawView.multiColorIsActive = false
    drawView.selectedLineColor = UIColor.cyan
  }
  @IBAction func multiColorButton(_ sender: Any) {
    drawView.multiColorIsActive = true
  }
  
}
