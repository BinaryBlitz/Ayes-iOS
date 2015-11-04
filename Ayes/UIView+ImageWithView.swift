//
//  UIView+ImageWithView.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

extension UIView {
  static func imageWithView(view: UIView) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let img = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  
    return img
  }
}