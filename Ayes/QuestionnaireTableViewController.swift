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
  
  enum QuestionnaireControllerStyle {
    case Modal
    case Normal
    case OtherUsers
  }

  var closeBarButtonItem: UIBarButtonItem?
  var menuBarButtonItem: UIBarButtonItem?
  var saveBarButtonItem: UIBarButtonItem?
  var doneBarButtonItem: UIBarButtonItem?
  var items = UserManager.sharedManager.avalableKeys
  var style: QuestionnaireControllerStyle = .Normal
  let gesturesView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
  
    doneBarButtonItem = UIBarButtonItem(title: "Done".localize(), style: .Done, target: self, action: "closeButtonAction:")
    closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeButtonAction:")
    menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: nil, action: "")
    saveBarButtonItem = UIBarButtonItem(title: "Save".localize(),
        style: .Done, target: self, action: "saveButtonAction:")
    switch style {
    case .OtherUsers:
      //same button as close
      if let doneButton = doneBarButtonItem {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = doneButton
      }
    case .Modal:
      if let closeButton = closeBarButtonItem {
        navigationItem.leftBarButtonItem = saveBarButtonItem
        navigationItem.rightBarButtonItem = closeButton
      }
    case .Normal:
      if let menuButton = menuBarButtonItem {
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = saveBarButtonItem
      }
      
      gesturesView.frame = tableView.frame
      
      if let revealViewController = revealViewController() {
        menuBarButtonItem!.target = revealViewController
        menuBarButtonItem!.action = "revealToggle:"
        gesturesView.addGestureRecognizer(revealViewController.tapGestureRecognizer())
        gesturesView.addGestureRecognizer(revealViewController.panGestureRecognizer())
        view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        revealViewController.delegate = self
      }
    }
    
    navigationItem.title = "Questionnaire".localize()
    let backItem = UIBarButtonItem(title: "Back".localize(), style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    
    if let localityIndex = items.indexOf(kLocality), user = UserManager.sharedManager.user {
      if Settings.sharedInstance.country == Settings.Country.World
            || user.region == "MOW" || user.region == "SPE" {
      
         items.removeAtIndex(localityIndex)
      }
    }
  }
  
  //MARK: - Actions
  
  @IBAction func closeButtonAction(sender: AnyObject) {
//    UserManager.sharedManager.updateUserIfPossible()
    dismissViewControllerAnimated(true, completion: nil)
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
  
  func saveButtonAction(sender: AnyObject) {
    if !UserManager.sharedManager.canUpdateUser() {
      presentCannotUpdateAlert()
      
      return
    } else if let user = UserManager.sharedManager.tmpUser where !user.isAllFieldsFilled() {
      let fillFieldAlert = UIAlertController(title: "Error".localize(), message: "You have to fill all the fields before saving".localize(), preferredStyle: .Alert)
      fillFieldAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
      
      presentViewController(fillFieldAlert, animated: true, completion: nil)
      return
    }
    
    let alert = UIAlertController(title: "Questionnaire".localize(),
        message: "saveQuestionnaireWarning".localize(), preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Save".localize(), style: .Default, handler: { (_) -> Void in
      ServerManager.sharedInstance.updateUser { (success) -> Void in
        
        var message: String?
        if success {
          message = "Success!".localize()
          UserManager.sharedManager.updateUserIfPossible()
          self.closeButtonAction(self)
        } else {
          message = "Error! Try again later.".localize()
        }
        
        let complitionAlert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        complitionAlert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(complitionAlert, animated: true, completion: nil)
      }
    }))
    
    alert.addAction(UIAlertAction(title: "Cancel".localize(), style: .Cancel, handler: nil))
    
    presentViewController(alert, animated: true, completion: nil)
  }
  
  //MARK: - TableView data source
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") else {
      return UITableViewCell()
    }
    
    let key = items[indexPath.row]
    let item = UserManager.sharedManager.valueForKey(key)
    cell.textLabel?.text = items[indexPath.row].localize()
    cell.detailTextLabel?.text = (item ?? "").localize()
    
    return cell
  }
  
  //MARK: - TableView delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    defer { tableView.deselectRowAtIndexPath(indexPath, animated: true) }
    
    guard UserManager.sharedManager.canUpdateUser() else {
      presentCannotUpdateAlert()
      return
    }
    
    if items[indexPath.row] ==  kBirthDate {
      performSegueWithIdentifier("dateChoice", sender: nil)
    } else if items[indexPath.row] == kRegion && Settings.sharedInstance.country == Settings.Country.World {
      performSegueWithIdentifier("countryChoice", sender: nil)
    } else {
      performSegueWithIdentifier("listChoice", sender: items[indexPath.row])
    }
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let itemKey = sender as? String,
        destination = segue.destinationViewController as? ListChoiceTableViewController
        where segue.identifier == "listChoice" {
      destination.delegate = self
      destination.item = itemKey
    } else if let destination = segue.destinationViewController as? DateChoiceTableViewController
        where segue.identifier == "dateChoice" {
      destination.delegate = self
    } else if let destination = segue.destinationViewController as? CountryPickerTableViewController
        where segue.identifier == "countryChoice" {
      destination.delegate = self
    }
  }
}

//MARK: QuestionnaireDataDisplay 

extension QuestionnaireTableViewController: QuestionnaireDataDisplay {
  func didUpdateValues() {
    if Settings.sharedInstance.country == Settings.Country.Russia {
      if let region = UserManager.sharedManager.valueForKey(kRegion) {
        if region == "MOW" || region == "SPE" {
          if let localityIndex = items.indexOf(kLocality) {
            items.removeAtIndex(localityIndex)
          }
        } else if items.indexOf(kLocality) == nil {
          if let regionIndex = items.indexOf(kRegion) {
            items.insert(kLocality, atIndex: regionIndex + 1)
          }
        }
      }
    } else {
      if let localityIndex = items.indexOf(kLocality) {
        items.removeAtIndex(localityIndex)
      }
    }
    
//    UserManager.sharedManager.saveToUserDefaults()
    tableView.reloadData()
  }
}

extension QuestionnaireTableViewController: SWRevealViewControllerDelegate {
  
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