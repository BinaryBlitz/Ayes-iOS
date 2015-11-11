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
  
  let gesturesView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    gesturesView.frame = view.frame
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      gesturesView.addGestureRecognizer(revealViewController.panGestureRecognizer())
      gesturesView.addGestureRecognizer(revealViewController.tapGestureRecognizer())
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
    backgroundImageView.alpha = 0.3
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Pro Version")
  }
}

extension ProViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    if position == .Left {
      gesturesView.removeFromSuperview()
    } else {
      view.addSubview(gesturesView)
    }
  }
}