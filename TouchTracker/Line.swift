//
//  Line.swift
//  TouchTracker
//
//  Created by Mischa Beumer on 3/21/17.
//  Copyright © 2017 msbbeumer. All rights reserved.
//

import UIKit
import CoreGraphics

struct Line {
  var begin = CGPoint.zero
  var end = CGPoint.zero
  var color = UIColor.blue
}

extension Line {
  
  var angleDegree : CGFloat {
    
    guard begin != end else { return 0 }
    
    let dX = end.x - begin.x
    let dY = end.y - begin.y
    
    var angle = atan2(dY, dX) * 180 / CGFloat(Double.pi)
    
    //make negative angles be positive and angles can go from 0 to 360
    if angle < 0 {
      angle = angle + 360
    }
    
    return CGFloat(angle)
    
  }
  var hueCode: CGFloat {
    return angleDegree / 360
  }
}
