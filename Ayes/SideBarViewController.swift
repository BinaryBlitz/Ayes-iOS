//
//  SideBarViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit


class SideBarViewController: UIViewController {
  
  @IBOutlet var buttons: [UIButton]!
  
  override func viewDidLoad() {
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
    
    for button in buttons {
      button.tintColor = UIColor.whiteColor()
      button.titleLabel?.font  = UIFont.systemFontOfSize(14)
      button.titleEdgeInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
    }
  }
}