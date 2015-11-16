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
  let minAge = 10
  let maxAge = 100

  @IBOutlet weak var clearBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var pickerView: UIPickerView!

  override func viewDidLoad() {
    super.viewDidLoad()

    clearBarButtonItem.title = "Clear".localize()

    if let ages = ComplexUserManager.sharedManager.user?.age where ages.count != 0 {
      pickerView.selectRow(ages[0] - minAge, inComponent: 0, animated: false)
      pickerView.selectRow(ages[1] - minAge, inComponent: 1, animated: false)
    } else {
      pickerView.selectRow(0, inComponent: 0, animated: false)
      pickerView.selectRow(maxAge - minAge - 1, inComponent: 1, animated: false)
    }
  }

  @IBAction func clearAction(sender: AnyObject) {
    ComplexUserManager.sharedManager.updateKey(kAge, withValues: [])
    pickerView.selectRow(0, inComponent: 0, animated: false)
    pickerView.selectRow(maxAge - minAge - 1, inComponent: 1, animated: false)
    delegate?.didUpdateValues()
  }

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "from - to".localize()
  }
}

extension BirthyearsTableViewController: UIPickerViewDataSource {

  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 2
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return maxAge - minAge
  }
}

extension BirthyearsTableViewController: UIPickerViewDelegate {

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return "\(minAge + row)"
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
            "\(pickerView.selectedRowInComponent(0) + minAge)",
            "\(pickerView.selectedRowInComponent(1) + minAge)"
    ]

    ComplexUserManager.sharedManager.updateKey(key, withValues: values)
    delegate?.didUpdateValues()
  }
}
