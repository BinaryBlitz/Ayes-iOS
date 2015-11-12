//
//  ChooseLanguageTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 13/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

@objc protocol MultipleChoiceControllerDelegate {
  optional func didChoseItem()
}

class ChooseLanguageTableViewController: UITableViewController {

  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  var avaliableLanguages = LocalizeHelper.sharedHelper.availableLanguages
  var selectedCell = 0
  weak var delegate: MultipleChoiceControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    doneBarButton.title = "Done".localize()
    cancelBarButton.title = "Cancel".localize()
    navigationItem.title = "App Language".localize()
    selectedCell = avaliableLanguages.indexOf(LocalizeHelper.getCurrentLanguage())!
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "languageCell")
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return avaliableLanguages.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("languageCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = avaliableLanguages[indexPath.row].localize()
    if indexPath.row == selectedCell {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }

    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    selectedCell = indexPath.row
    tableView.reloadData()
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func doneAction(sender: AnyObject) {
    LocalizeHelper.setLanguage(avaliableLanguages[selectedCell])
    Settings.sharedInstance.language = avaliableLanguages[selectedCell]
    if let delegate = delegate {
      delegate.didChoseItem?()
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  }
}
