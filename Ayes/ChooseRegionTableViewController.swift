//
//  ChooseRegionTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 13/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ChooseRegionTableViewController: UITableViewController {

  @IBOutlet weak var cancelBarButton: UIBarButtonItem!
  @IBOutlet weak var doneBarButton: UIBarButtonItem!
  var avaliableRegions = ["rus", "other"]
  var selectedCell = 0
  weak var delegate: MultipleChoiceControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    doneBarButton.title = LocalizeHelper.localizeStringForKey("Done")
    cancelBarButton.title = LocalizeHelper.localizeStringForKey("Cancel")
    navigationItem.title = LocalizeHelper.localizeStringForKey("Your Region")
    selectedCell = avaliableRegions.indexOf(Settings.sharedInstance.region ?? "rus")!
    tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "regionCell")
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return avaliableRegions.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("regionCell", forIndexPath: indexPath)
    
    cell.textLabel?.text = LocalizeHelper.localizeStringForKey(avaliableRegions[indexPath.row])
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
    Settings.sharedInstance.region = avaliableRegions[selectedCell]
    if let delegate = delegate {
      delegate.didChoseItem?()
    }
    
    dismissViewControllerAnimated(true, completion: nil)
  }
}
