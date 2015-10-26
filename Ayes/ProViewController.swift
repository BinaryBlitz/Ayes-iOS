//
//  ProViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ProViewController: UIViewController {

  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var backgroundImageView: UIImageView!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
    backgroundImageView.alpha = 0.3
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Pro Version")
  }
}

//MARK: - SWRevealViewControllerDelegate

extension ProViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    view.userInteractionEnabled = position == .Left
  }
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    view.userInteractionEnabled = position == .Left
  }
}