//
//  SetQuestionTimeTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 13/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class SetQuestionTimeTableViewController: UITableViewController {

  @IBOutlet weak var timePicker: UIDatePicker!
  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  weak var delegate: MultipleChoiceControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    timePicker.date = Settings.sharedInstance.questionTime
    doneBarButton.title = LocalizeHelper.localizeStringForKey("Done")
    cancelBarButton.title = LocalizeHelper.localizeStringForKey("Cancel")
    navigationItem.title = LocalizeHelper.localizeStringForKey("Question Time")
  }
  
  override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    return false
  }
  
  @IBAction func cancelAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func doneAction(sender: AnyObject) {
    Settings.sharedInstance.questionTime = timePicker.date
    delegate?.didChoseItem?()
    dismissViewControllerAnimated(true, completion: nil)
  }
}
