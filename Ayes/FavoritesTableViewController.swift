//
//  FavoritesTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class FavoritesTableViewController: UITableViewController {
  
  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  
  override func viewDidLoad() {
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.rearViewRevealWidth = SIDE_BAR_WIDTH
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Favorites")
  }
}
