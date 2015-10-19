//
//  QuestionnaireTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import SWRevealViewController

class QuestionnaireTableViewController: UITableViewController {

  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Questionnaire")

  }
}

//MARK: - SWRevealViewControllerDelegate

extension QuestionnaireTableViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
}