//
//  CreateFormsTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class CreateFormsTableViewController: UITableViewController {

  @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
  let items = ComplexUserManager.sharedManager.avalableKeys

  var question: Question!
  weak var statDelegate: StatDataDisplay?
  var delegate: CreateFormsDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    cancelBarButtonItem.title = "Cancel".localize()
    doneBarButtonItem.title = "Done".localize()
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") else {
      return UITableViewCell()
    }
    
    let key = items[indexPath.row]
    cell.textLabel?.text = key.localize()
    if let selectedValues = ComplexUserManager.sharedManager.valuesForKey(key) {
      let localizedSelectedValues = selectedValues.flatMap { (element) -> String? in
        return element.localize()
      }
      
      let detailString = localizedSelectedValues.joinWithSeparator(", ")
      cell.detailTextLabel?.text = detailString
    } else {
      cell.detailTextLabel?.text = ""
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    let key = items[indexPath.row]
    if key == kBirthDate {
      performSegueWithIdentifier("birthdateChoice", sender: key)
    } else {
      performSegueWithIdentifier("listChoice", sender: key)
    }
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  @IBAction func cancelButtonAction(sender: AnyObject) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  @IBAction func doneButtonAction(sender: AnyObject) {

    guard let user = ComplexUserManager.sharedManager.user else {
      return
    }

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    indicator.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
    indicator.layer.cornerRadius = 10
    indicator.backgroundColor = UIColor.darkVioletPrimaryColor()
    indicator.center = view.center
    indicator.center.y -= 120
    view.addSubview(indicator)
    view.bringSubviewToFront(indicator)

    indicator.startAnimating()


    ServerManager.sharedInstance
      .getSimilarAnswersWithForms(user, forQuestion: question) { (stat) in
          indicator.stopAnimating()
          if let stat = stat {
            self.statDelegate?.didChangeStatType(.Other(stat: stat))
            self.delegate?.didUpdateStat()
            self.dismissViewControllerAnimated(true, completion: nil)
          } else {
            self.presentErrorAlert()
          }
    }
  }
  
  func presentErrorAlert() {
    let alert = UIAlertController(title: nil, message: "Error! Try again later.".localize(), preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    presentViewController(alert, animated:  true, completion: nil)
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? MultipleListChoiceTableViewController,
          key = sender as? String where segue.identifier == "listChoice" {
      destination.key = key
      destination.delegate = self
    } else if let destionation = segue.destinationViewController as? BirthyearsTableViewController,
        key = sender as? String where segue.identifier == "birthdateChoice" {
      destionation.key = key
      destionation.delegate = self
    }
  }
}

extension CreateFormsTableViewController: QuestionnaireDataDisplay {
  func didUpdateValues() {
    tableView.reloadData()
  }
}
