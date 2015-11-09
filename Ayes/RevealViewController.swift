//
//  RevealViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class RevealViewController: SWRevealViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    rearViewRevealWidth = sideBarWidth
    rearViewRevealDisplacement = 0
    toggleAnimationType = SWRevealToggleAnimationType.Spring
    toggleAnimationDuration = 0.2
    bounceBackOnOverdraw = false
    rearViewRevealOverdraw = 0
  }
}
