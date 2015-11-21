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
    
    yesButton.setTitle("Yes".localize(), forState: .Normal)
    yesButton.tintColor = UIColor.whiteColor()
    yesButton.layer.cornerRadius = 45
    yesButton.backgroundColor = nil
    yesButton.layer.borderWidth = 2
    yesButton.layer.borderColor = UIColor.greenAccentColor().CGColor
    noButton.setTitle("No".localize(), forState: .Normal)
    noButton.layer.cornerRadius = 45
    noButton.backgroundColor = nil
    noButton.layer.borderWidth = 2
    noButton.tintColor = UIColor.whiteColor()
    noButton.layer.borderColor = UIColor.redAccentColor().CGColor
    
    skipButton.tintColor = UIColor.whiteColor()
    skipButton.setTitle("Skip".localize(), forState: .Normal)
  }
  
  func updateQuestionState(state: QuestionState) {
    question.updateState(state)
    guard let id = question.id?.integerValue else {
      return
    }
    
    if let answer = Answer.createWithQuestion(question) {
      ServerManager.sharedInstance.submitAnswer(id, answer: state) { (success) -> Void in
        if success {
          answer.sentToServer = true
        }
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
