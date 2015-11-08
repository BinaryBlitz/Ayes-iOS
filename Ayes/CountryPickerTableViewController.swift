//
//  CountryPickerTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 08/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class CountryPickerTableViewController: UITableViewController {

  @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var countryPicker: CountryPicker!
  weak var delegate: QuestionnaireDataDisplay?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let user = UserManager.sharedManager.user
    
    if let region = user?.region {
      if User.Region.optionsList.contains(region) {
        fatalError("Wrong region")
      } else {
        countryPicker.selectedCountryCode = region
      }
    }

    saveBarButtonItem.title = LocalizeHelper.localizeStringForKey("Save")
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    
    countryPicker.selectedLocale = NSLocale(localeIdentifier: LocalizeHelper.sharedHelper.currentLanguage)
  }
  
  @IBAction func saveButtonAction(sender: AnyObject) {
    UserManager.sharedManager.updateKey(kRegion, withValue: countryPicker.selectedCountryCode)
    delegate?.didUpdateValues()
    navigationController?.popViewControllerAnimated(true)
  }
}