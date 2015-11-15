//
//  MultipleListChoiceTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class MultipleListChoiceTableViewController: UITableViewController {
  
  var key: String!
  var options = [String]()
  var selectedOptions = [String]()
  weak var delegate: QuestionnaireDataDisplay?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    options = ComplexUserManager.sharedManager.optionsForKey(key)
    if let values = ComplexUserManager.sharedManager.valuesForKey(key) {
      selectedOptions = values
    }
  }

  // MARK: - Table view data source

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return options.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("optionCell") else {
      return UITableViewCell()
    }
    
    cell.textLabel?.text = options[indexPath.row].localize()
    if selectedOptions.contains(options[indexPath.row]) {
      cell.accessoryType = .Checkmark
    } else {
      cell.accessoryType = .None
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let cell = tableView.cellForRowAtIndexPath(indexPath)
    
    let option = options[indexPath.row]
    if selectedOptions.contains(option) {
      cell?.accessoryType = .None
      if let indexOfOption = selectedOptions.indexOf(option) {
        selectedOptions.removeAtIndex(indexOfOption)
      }
    } else {
      cell?.accessoryType = .Checkmark
      selectedOptions.append(option)
    }
    
    ComplexUserManager.sharedManager.updateKey(key, withValues: selectedOptions)
    
    delegate?.didUpdateValues()
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
}
