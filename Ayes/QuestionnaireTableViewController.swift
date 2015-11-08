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
  }

  var closeBarButtonItem: UIBarButtonItem?
  var menuBarButtonItem: UIBarButtonItem?
  var items = UserManager.sharedManager.avalableKeys
  var style: QuestionnaireControllerStyle = .Normal
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    switch style {
    case .Modal:
      closeBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeButtonAction:")
      if let closeButton = closeBarButtonItem {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = closeButton
      }
    case .Normal:
      menuBarButtonItem = UIBarButtonItem(image: UIImage(named: "Menu"), style: .Plain, target: nil, action: "")
      if let menuButton = menuBarButtonItem {
        navigationItem.leftBarButtonItem = menuButton
        navigationItem.rightBarButtonItem = nil
      }
      
      if let revealViewController = revealViewController() {
        menuBarButtonItem?.target = revealViewController
        menuBarButtonItem?.action = "revealToggle:"
        view.addGestureRecognizer(revealViewController.panGestureRecognizer())
        revealViewController.delegate = self
      }
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Questionnaire")
    let backItem = UIBarButtonItem(title: LocalizeHelper.localizeStringForKey("Back"), style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    
//    if Settings.sharedInstance.country == Settings.Country.World {
//      items.removeAtIndex(items.indexOf(kRegion)!)
//    }
  }
  
  @IBAction func closeButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
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
    cell.textLabel?.text = LocalizeHelper.localizeStringForKey(items[indexPath.row])
    cell.detailTextLabel?.text = LocalizeHelper.localizeStringForKey(item ?? "")
    
    return cell
  }
  
  //MARK: - TableView delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    if items[indexPath.row] ==  kBirthDate {
      performSegueWithIdentifier("dateChoice", sender: nil)
    } else if items[indexPath.row] == kRegion && Settings.sharedInstance.country == Settings.Country.World {
      performSegueWithIdentifier("countryChoice", sender: nil)
    } else {
      performSegueWithIdentifier("listChoice", sender: items[indexPath.row])
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
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

//MARK: - SWRevealViewControllerDelegate

extension QuestionnaireTableViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
}

//MARK: QuestionnaireDataDisplay 

extension QuestionnaireTableViewController: QuestionnaireDataDisplay {
  func didUpdateValues() {
    UserManager.sharedManager.saveToUserDefaults()
    ServerManager.sharedInstance.updateUser { (success) -> Void in
      print("user updated with success: \(success)")
    }
    tableView.reloadData()
  }
}