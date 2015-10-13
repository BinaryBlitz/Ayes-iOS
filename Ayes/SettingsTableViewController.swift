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
  @IBOutlet weak var questionTimeLabel: UILabel!
  @IBOutlet weak var questionTimeValueLabel: UILabel!
  @IBOutlet weak var notificationsLabel: UILabel!
  @IBOutlet weak var newQuestionsnotificationLabel: UILabel!
  @IBOutlet weak var favoriteQuestionsLabel: UILabel!
  @IBOutlet var notificationsCells: [UITableViewCell]!

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
  
  @IBAction func notificationsSwitch(sender: AnyObject) {
    if let switcher =  sender as? UISwitch {
      if switcher.on {
        for cell in notificationsCells {
          let sw = cell.viewWithTag(2) as! UISwitch
          sw.setOn(true, animated: true)
          sw.enabled = true
          cell.userInteractionEnabled = true
          let label = cell.viewWithTag(1) as! UILabel
          label.enabled = true
        }
      } else {
        for cell in notificationsCells {
          let sw = cell.viewWithTag(2) as! UISwitch
          sw.setOn(false, animated: true)
          sw.enabled = false
          cell.userInteractionEnabled = false
          let label = cell.viewWithTag(1) as! UILabel
          label.enabled = false
        }
      }
    }
  }
  
  @IBAction func newQuestionsSwitch(sender: AnyObject) {
  }
  
  @IBAction func favoriteQuestionsSwitch(sender: AnyObject) {
  }
  
  func reloadContent() {
    navigationItem.title = LocalizeHelper.localizeStringForKey("Settings")
    languageLabel.text = LocalizeHelper.localizeStringForKey("Language")
    languageValueLabel.text = LocalizeHelper.localizeStringForKey(LocalizeHelper.getCurrentLanguage())
    regionLabel.text = LocalizeHelper.localizeStringForKey("Region")
    regionValueLabel.text = LocalizeHelper.localizeStringForKey(Settings.sharedInstance.region ?? "")
    questionTimeLabel.text = LocalizeHelper.localizeStringForKey("Question Time")
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm"
    questionTimeValueLabel.text = formatter.stringFromDate(Settings.sharedInstance.questionTime)
    notificationsLabel.text = LocalizeHelper.localizeStringForKey("Notifications")
    newQuestionsnotificationLabel.text = LocalizeHelper.localizeStringForKey("New question notifications")
    favoriteQuestionsLabel.text = LocalizeHelper.localizeStringForKey("Favorite questions notifications")
    
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
    } else if segue.identifier == "chooseRegion" {
      guard let navController = segue.destinationViewController as? UINavigationController else {
        return
      }
      
      if let destination = navController.viewControllers.first as? ChooseRegionTableViewController {
          destination.delegate = self
      }
    }
    
  }
}

extension SettingsTableViewController: MultipleChoiceControllerDelegate {
  func didChoseItem() {
    reloadContent()
    Settings.saveToUserDefaults()
  }
}
