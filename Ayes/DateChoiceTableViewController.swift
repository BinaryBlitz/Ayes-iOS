//
//  DateChoiceTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 24/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class DateChoiceTableViewController: UITableViewController {

  @IBOutlet weak var datePicker: UIDatePicker!
  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  weak var delegate: QuestionnaireDataDisplay?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    datePicker.locale = NSLocale(localeIdentifier: LocalizeHelper.sharedHelper.currentLanguage)
    saveBarButtonItem.title = LocalizeHelper.localizeStringForKey("Save")
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    if let birthDate = UserManager.sharedManager.user?.birthDate {
      datePicker.date = birthDate
    }
  }
  
  @IBAction func saveButtonAction(sender: AnyObject) {
    UserManager.sharedManager.user?.birthDate = datePicker.date
    delegate?.didUpdateValues()
    navigationController?.popViewControllerAnimated(true)
  }
}
