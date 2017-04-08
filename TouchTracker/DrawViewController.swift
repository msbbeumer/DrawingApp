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
  
  override func viewDidLoad() {
    colorPanel.isHidden = true
    
  }
  
}
