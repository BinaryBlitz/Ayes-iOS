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
  @IBOutlet weak var mainNotificationCell: UITableViewCell!
  @IBOutlet weak var newQuestionNotificationCell: UITableViewCell!
  @IBOutlet weak var favoriteQuestionNotificationCell: UITableViewCell!
  
  let gesturesView = UIView()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Side Bar Gestures
    
    gesturesView.frame = tableView.frame
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      gesturesView.addGestureRecognizer(revealViewController.panGestureRecognizer())
      gesturesView.addGestureRecognizer(revealViewController.tapGestureRecognizer())
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    reloadContent()
    
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    
    if UIApplication.sharedApplication().isRegisteredForRemoteNotifications() {
      Settings.sharedInstance.favoriteQuestionsNotifications = true
      Settings.sharedInstance.newQuestionNotifications = true
      Settings.saveToUserDefaults()
    }
    
    
    let registered =
        Settings.sharedInstance.favoriteQuestionsNotifications ||
                Settings.sharedInstance.newQuestionNotifications


    if let sw = newQuestionNotificationCell.viewWithTag(2) as? UISwitch {
      sw.on = Settings.sharedInstance.newQuestionNotifications
    }

    if let sw = favoriteQuestionNotificationCell.viewWithTag(2) as? UISwitch {
      sw.on = Settings.sharedInstance.favoriteQuestionsNotifications
    }

    if !registered {
      if let sw = mainNotificationCell.viewWithTag(2) as? UISwitch {
        sw.on = registered
      }

      for cell in notificationsCells {
        //set up switch
        let sw = cell.viewWithTag(2) as! UISwitch
        sw.setOn(registered, animated: true)
        sw.enabled = registered

        //set up label
        let label = cell.viewWithTag(1) as! UILabel
        label.enabled = registered
        cell.userInteractionEnabled = registered
      }
    }
  }
  
  @IBAction func notificationsSwitch(sender: AnyObject) {
    guard let switcher = sender as? UISwitch else {
      return
    }

    Settings.sharedInstance.newQuestionNotifications = switcher.on
    Settings.sharedInstance.favoriteQuestionsNotifications = switcher.on
    Settings.saveToUserDefaults()
    ServerManager.sharedInstance.updateSettings()

    for cell in notificationsCells {
      let sw = cell.viewWithTag(2) as! UISwitch
      sw.setOn(switcher.on, animated: true)
      sw.enabled = switcher.on
      cell.userInteractionEnabled = switcher.on
      let label = cell.viewWithTag(1) as! UILabel
      label.enabled = switcher.on
    }

    if switcher.on {
      ServerManager.sharedInstance.updateDeviceToken(ServerManager.sharedInstance.deviceToken)
    } else {
      ServerManager.sharedInstance.updateDeviceToken()
    }

    ServerManager.sharedInstance.updateSettings()
  }
  
  @IBAction func newQuestionsSwitch(sender: AnyObject) {
    guard let switcher = sender as? UISwitch else {
      return
    }

    Settings.sharedInstance.newQuestionNotifications = switcher.on

    if !(Settings.sharedInstance.favoriteQuestionsNotifications || switcher.on) {
      if let sw = mainNotificationCell.viewWithTag(2) as? UISwitch {
        sw.setOn(false, animated: true)
        notificationsSwitch(sw)
        return
      }
    }
    Settings.saveToUserDefaults()
    ServerManager.sharedInstance.updateSettings()
  }
  
  @IBAction func favoriteQuestionsSwitch(sender: AnyObject) {
    guard let switcher = sender as? UISwitch else {
      return
    }

    Settings.sharedInstance.favoriteQuestionsNotifications = switcher.on

    if !(Settings.sharedInstance.newQuestionNotifications || switcher.on) {
      if let sw = mainNotificationCell.viewWithTag(2) as? UISwitch {
        sw.setOn(false, animated: true)
        notificationsSwitch(sw)
        return
      }
    }
    Settings.saveToUserDefaults()
    ServerManager.sharedInstance.updateSettings()
  }
  
  func reloadContent() {
    navigationItem.title = "Settings".localize()
    languageLabel.text = "Language".localize()
    languageValueLabel.text = LocalizeHelper.getCurrentLanguage().localize()
    regionLabel.text = "region".localize()
    regionValueLabel.text = (Settings.sharedInstance.country?.rawValue ?? "").localize()
    questionTimeLabel.text = "Question Time".localize()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "HH:mm"
    questionTimeValueLabel.text = formatter.stringFromDate(Settings.sharedInstance.questionTime)
    notificationsLabel.text = "Notifications".localize()
    newQuestionsnotificationLabel.text = "New question notifications".localize()
    favoriteQuestionsLabel.text = "Favorite questions notifications".localize()
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
    print(indexPath.row)

    guard UserManager.sharedManager.canUpdateUser() else {
      presentCannotUpdateAlert()
      if UserManager.sharedManager.lastUpdate == nil {
        performSegueWithIdentifier("chooseRegion", sender: nil)
      }

      return
    }

    if indexPath.row == 1 {
      performSegueWithIdentifier("chooseRegion", sender: nil)
    }

  }

  func presentCannotUpdateAlert() {
    if let lastUpdate = UserManager.sharedManager.lastUpdate {
      let timeInterval = -lastUpdate.timeIntervalSinceNow
      let days = round(timeInterval / (24 * 60 * 60))

      let updateAlert = UIAlertController(title: "Error".localize(), message: "You can update your questionnaire only after \(Int(7 - days)) days".localize(), preferredStyle: .Alert)
      updateAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      presentViewController(updateAlert, animated: true, completion: nil)
    }
  }

  //MARK: - Navigation

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
    } else if let destinationNavController = segue.destinationViewController as? UINavigationController
          where segue.identifier == "setQuestionTime" {
      guard let destination = destinationNavController.viewControllers.first as?
          SetQuestionTimeTableViewController else {
        return
      }
            
      destination.delegate = self
    }
  }
}

extension SettingsTableViewController: MultipleChoiceControllerDelegate {
  func didChoseItem() {
    reloadContent()
    Settings.saveToUserDefaults()
    ServerManager.sharedInstance.updateSettings { (success) -> Void in
      print("settings uploaded: \(success)")
    }
  }

  func didUpdateCountry() {
    reloadContent()
    Settings.saveToUserDefaults()
    ServerManager.sharedInstance.updateSettings { (success) -> Void in
      print("settings uploaded: \(success)")
      if success {
        ServerManager.sharedInstance.getQuestions {
          (questions) in
          NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
        }
      }
    }
  }
}

extension SettingsTableViewController: SWRevealViewControllerDelegate {
  
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    if position == .Left {
      gesturesView.removeFromSuperview()
      tableView.scrollEnabled = true
    } else {
      view.addSubview(gesturesView)
      tableView.scrollEnabled = false
    }
  }
}