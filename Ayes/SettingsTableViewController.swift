//
//  SettingsTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
  
  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var languageLabel: UILabel!
  @IBOutlet weak var languageValueLabel: UILabel!
  @IBOutlet weak var regionLabel: UILabel!
  @IBOutlet weak var regionValueLabel: UILabel!
  @IBOutlet weak var questiontimeLabel: UILabel!
  @IBOutlet weak var notificationsLabel: UILabel!
  @IBOutlet weak var newQuestionsnotificationLabel: UILabel!
  @IBOutlet weak var favoriteQuestionsLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.rearViewRevealWidth = SIDE_BAR_WIDTH
    }
    
    reloadContent()
    
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
  }
  
  func reloadContent() {
    navigationItem.title = LocalizeHelper.localizeStringForKey("Settings")
    languageLabel.text = LocalizeHelper.localizeStringForKey("Language")
    languageValueLabel.text = LocalizeHelper.localizeStringForKey(LocalizeHelper.getCurrentLanguage())
    regionLabel.text = LocalizeHelper.localizeStringForKey("Region")
    regionValueLabel.text = LocalizeHelper.localizeStringForKey(Settings.sharedInstance.region)
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    switch indexPath.row {
    case 0, 1, 2:
      return true
    default:
      return false
    }
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "chooseLanguage" {
      guard let navController = segue.destinationViewController as? UINavigationController else {
        return
      }
      
      if let destination = navController.viewControllers.first as? ChooseLanguageTableViewController {
          destination.delegate = self
      }
    }
  }
}

extension SettingsTableViewController: ChooseLanguageDelegate {
  func didChangeLanguage() {
    reloadContent()
  }
}
