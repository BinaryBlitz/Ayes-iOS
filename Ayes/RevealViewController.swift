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
    rearViewRevealWidth = SIDE_BAR_WIDTH
    rearViewRevealDisplacement = 60
    toggleAnimationType = SWRevealToggleAnimationType.Spring
    toggleAnimationDuration = 0.2
    bounceBackOnOverdraw = false
    rearViewRevealOverdraw = 0
  }
}
