//
//  BirthyearsTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class BirthyearsTableViewController: UITableViewController {

  var key: String!
  weak var delegate: QuestionnaireDataDisplay?
  let minYear = 1940
  let maxYear = 2009
  
  @IBOutlet weak var pickerView: UIPickerView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let complexDate = ComplexUserManager.sharedManager.user?.birthDate {
      let years = complexDate.getYearsArray()
      pickerView.selectRow(years[0] - minYear, inComponent: 0, animated: false)
      pickerView.selectRow(years[1] - minYear, inComponent: 1, animated: false)
    }
  }
}

extension BirthyearsTableViewController: UIPickerViewDataSource {
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 2
  }
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return maxYear - minYear
  }
}

extension BirthyearsTableViewController: UIPickerViewDelegate {
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(minYear + row)"
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if component == 0 {
      let selected = pickerView.selectedRowInComponent(0)
      let selectedInSecond = pickerView.selectedRowInComponent(1)
      if selected > selectedInSecond {
        pickerView.selectRow(selected, inComponent: 1, animated: true)
      }
    } else if component == 1 {
      let selected = pickerView.selectedRowInComponent(1)
      let selectedInFirst = pickerView.selectedRowInComponent(0)
      if selected < selectedInFirst {
        pickerView.selectRow(selected, inComponent: 0, animated: true)
      }
    }
    
    let values = [
      "\(pickerView.selectedRowInComponent(0) + minYear)",
      "\(pickerView.selectedRowInComponent(1) + minYear)"
    ]
    
    ComplexUserManager.sharedManager.updateKey(key, withValues: values)
    delegate?.didUpdateValues()
  }
}
