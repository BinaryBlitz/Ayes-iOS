//
//  UIColor+Ayes.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIColor {
  
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat = 1) {
      self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: alpha)
  }
  
  static func violetPrimaryColor() -> UIColor {
    return UIColor(r: 66, g: 54, b: 82)
  }
  
  static func darkVioletPrimaryColor() -> UIColor {
    return UIColor(r: 53, g: 43, b: 66)
  }
  
  static func lightGreenBackgroundColor() -> UIColor {
    return UIColor(r: 233, g: 245, b: 239)
  }
  
  static func blueAccentColor() -> UIColor {
    return UIColor(r: 85, g: 222, b: 242)
  }
  
  static func greenAccentColor() -> UIColor {
    return UIColor(r: 101, g: 225, b: 165)
  }
  
  static func redAccentColor() -> UIColor {
    return UIColor(r: 255, g: 76, b: 127)
  }
}
