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
  @IBOutlet weak var settingsButton: UIButton!
  @IBOutlet weak var proButton: UIButton!
  @IBOutlet weak var questionnareButton: UIButton!
  @IBOutlet weak var favoritesButton: UIButton!
  @IBOutlet weak var homeButton: UIButton!
  @IBOutlet weak var buttonWidthLayoutConstraint: NSLayoutConstraint!
  @IBOutlet var buttonsSpacingConstaraints: [NSLayoutConstraint]!
  
  override func viewWillAppear(animated: Bool) {
    settingsButton.setTitle(LocalizeHelper.localizeStringForKey("Settings"), forState: .Normal)
    proButton.setTitle(LocalizeHelper.localizeStringForKey("Pro Version"), forState: .Normal)
    questionnareButton.setTitle(LocalizeHelper.localizeStringForKey("Questionnaire"), forState: .Normal)
    favoritesButton.setTitle(LocalizeHelper.localizeStringForKey("Favorites"), forState: .Normal)
    homeButton.setTitle(LocalizeHelper.localizeStringForKey("Home"), forState: .Normal)
  }
  
  override func viewDidLoad() {
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
    buttonWidthLayoutConstraint.constant = sideBarButtonsWidth
    
    for constraint in buttonsSpacingConstaraints {
      if sideBarButtonsWidth < 100 {
        constraint.constant = 6
      } else {
        constraint.constant = 8
      }
    }
    
    for button in buttons {
      button.tintColor = UIColor.whiteColor()
      if sideBarButtonsWidth < 100 {
        button.titleLabel?.font  = UIFont.systemFontOfSize(12)
      } else {
        button.titleLabel?.font  = UIFont.systemFontOfSize(14)
      }
      button.titleEdgeInsets = UIEdgeInsets(top: 35, left: 0, bottom: 0, right: 0)
    }
  }
}
