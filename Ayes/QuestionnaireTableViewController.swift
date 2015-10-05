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
    
    let title = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
    title.textAlignment = .Left
    title.text = "Анкета пользователя"
    title.textColor = UIColor.whiteColor()
    navigationItem.titleView = title
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.rearViewRevealWidth = SIDE_BAR_WIDTH
    }

  }
  
  


}

