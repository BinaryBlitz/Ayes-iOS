//
//  QuestionControlsViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 14/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Crashlytics

@objc protocol QuestionControlsDelegate {
  optional func didAnswerTheQuestion()
}

class QuestionControlsViewController: UIViewController {

  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  var question: Question!
  var delegate: QuestionControlsDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.violetPrimaryColor()
    
    yesButton.setTitle(LocalizeHelper.localizeStringForKey("Yes"), forState: .Normal)
    yesButton.tintColor = UIColor.whiteColor()
    yesButton.layer.cornerRadius = yesButton.frame.height / 2
    yesButton.backgroundColor = nil
    yesButton.layer.borderWidth = 3
    yesButton.layer.borderColor = UIColor.greenAccentColor().CGColor
    noButton.setTitle(LocalizeHelper.localizeStringForKey("No"), forState: .Normal)
    noButton.layer.cornerRadius = noButton.frame.height / 2
    noButton.backgroundColor = nil
    noButton.layer.borderWidth = 3
    noButton.tintColor = UIColor.whiteColor()
    noButton.layer.borderColor = UIColor.redAccentColor().CGColor
    
    skipButton.tintColor = UIColor.whiteColor()
    skipButton.setTitle(LocalizeHelper.localizeStringForKey("Skip"), forState: .Normal)
  }

  @IBAction func yesButtonAction(sender: AnyObject) {
    question.updateState(.Yes)
    delegate?.didAnswerTheQuestion?()
  }
  
  @IBAction func noButtonAction(sender: AnyObject) {
    question.updateState(.No)
    delegate?.didAnswerTheQuestion?()
  }
  
  @IBAction func skipButtonAction(sender: AnyObject) {
    question.updateState(.Skip)
    delegate?.didAnswerTheQuestion?()
  }
}
