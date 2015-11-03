//
//  QuestionControlsViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 14/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import Crashlytics

class QuestionControlsViewController: UIViewController {

  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var yesButton: UIButton!
  @IBOutlet weak var noButton: UIButton!
  var question: Question!
  weak var delegate: QuestionChangesDelegate?
  
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
  
  func updateQuestionState(state: QuestionState) {
    question.updateState(state)
    guard let id = question.id?.integerValue else {
      print("Question have no id!?!")
      return
    }
    
    ServerManager.sharedInstance.submitAnswer(id, answer: state) { (success) -> Void in
      if success {
        print("uploaded!")
      }
    }
  }

  @IBAction func yesButtonAction(sender: AnyObject) {
    updateQuestionState(.Yes)
    delegate?.didAnswerTheQuestion?(question)
  }
  
  @IBAction func noButtonAction(sender: AnyObject) {
    updateQuestionState(.No)
    delegate?.didAnswerTheQuestion?(question)
  }
  
  @IBAction func skipButtonAction(sender: AnyObject) {
    updateQuestionState(.Skip)
    delegate?.didAnswerTheQuestion?(question)
  }
}
