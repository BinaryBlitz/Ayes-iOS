//
//  ListChoiceTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 24/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ListChoiceTableViewController: UITableViewController {
  
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  var item: String!
  var selectedIndex: Int?
  weak var delegate: QuestionnaireDataDisplay?
  var options: [String] {
    return UserManager.sharedManager.optionsForKey(item).sort(<)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    
    saveBarButtonItem.title = LocalizeHelper.localizeStringForKey("Save")
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = 50
    if let value = UserManager.sharedManager.valueForKey(item) {
      selectedIndex = options.indexOf(value)
    }
  }
  
  //MARK: - Actions
  
  @IBAction func saveButtonAction(sender: AnyObject) {
    if let selectedIndex = selectedIndex {
      let selectedOption = options[selectedIndex]
      UserManager.sharedManager.updateKey(item, withValue: selectedOption)
      delegate?.didUpdateValues()
    }
    navigationController?.popToRootViewControllerAnimated(true)
  }

  // MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return options.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("listItemCell") else {
      return UITableViewCell()
    }
    
    let row = indexPath.row
    cell.accessoryType = row == selectedIndex ? .Checkmark : .None
    cell.textLabel?.text = LocalizeHelper.localizeStringForKey(options[row])

    return cell
  }
  
  // MARK: - Table view delegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    defer { tableView.deselectRowAtIndexPath(indexPath, animated: true) }
    
    if selectedIndex == indexPath.row {
      return
    }
    
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    if let selectedIndex = selectedIndex {
      let selectedCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
      selectedCell?.accessoryType = .None
    }
    cell?.accessoryType = .Checkmark
    self.selectedIndex = indexPath.row
  }
  
}
