//
//  QuestionViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 14/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  
  @IBOutlet weak var controlsContainer: UIView!
  var question: Question!

  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var questionDateLabel: UILabel!
  @IBOutlet weak var questionIdLabel: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.violetPrimaryColor()
    contentTextView.text = question.content
    contentTextView.font = UIFont.systemFontOfSize(18)
    contentTextView.textColor = UIColor.whiteColor()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    questionDateLabel.text = formatter.stringFromDate(question.dateCreated ?? NSDate())
    
    questionIdLabel.text = "\(question.id ?? 0)"
//    navigationItem.leftBarButtonItem?.title = "Back"
    warningLabel.text = LocalizeHelper.localizeStringForKey("SkipWarning")
    
    print(question.content)

  }
  
  func backButtonAction(sender: AnyObject) {
    navigationController?.popViewControllerAnimated(true)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "controlsSetUp" {
      print("Yeeeeeeeahhhh")
    }
  }
}
