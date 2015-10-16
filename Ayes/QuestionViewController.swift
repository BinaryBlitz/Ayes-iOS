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
  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var questionDateLabel: UILabel!
  @IBOutlet weak var questionIdLabel: UILabel!
  
  var question: Question!
  var delegate: QuestionControlsDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.violetPrimaryColor()
    contentTextView.text = question.content
    contentTextView.font = UIFont.systemFontOfSize(17)
    contentTextView.textColor = UIColor.whiteColor()
    contentTextView.scrollEnabled = false
    contentTextView.textContainer.lineBreakMode = .ByTruncatingTail
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    questionDateLabel.text = formatter.stringFromDate(question.dateCreated ?? NSDate())
    
    questionIdLabel.text = "\(question.id ?? 0)"
    warningLabel.text = LocalizeHelper.localizeStringForKey("SkipWarning")
    
    if question.state != .NoAnswer {
      showResults(false)
    }
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "controlsSetUp" {
      let destination = segue.destinationViewController as! QuestionControlsViewController
      destination.delegate = self
      destination.question = question
    }
  }
  
  func shareButtonAction(sender: AnyObject) {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    actionSheet.addAction(UIAlertAction(title: LocalizeHelper.localizeStringForKey("Cancel"), style: UIAlertActionStyle.Cancel, handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Twitter", style: .Default, handler: nil))
    actionSheet.addAction(UIAlertAction(title: "Facebook", style: .Default, handler: nil))
    actionSheet.addAction(UIAlertAction(title: LocalizeHelper.localizeStringForKey("VK"), style: .Default, handler: nil))
    presentViewController(actionSheet, animated: true, completion: nil)
  }
  
  func favoriteButtonAction(sender: AnyObject) {
    if let starButton = navigationItem.titleView as? UIButton {
      starButton.selected = !starButton.selected
    }
  }
  
  func showResults(animated: Bool) {
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonAction:")
    let starButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    starButton.imageView?.image = UIImage(named: "Favorite")
    starButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
    let filledImage = UIImage(named: "FavoriteFilled")
    starButton.setImage(filledImage, forState: UIControlState.Highlighted)
    starButton.setImage(filledImage, forState: UIControlState.Selected)
    starButton.addTarget(self, action: "favoriteButtonAction:", forControlEvents: .TouchUpInside)
    navigationItem.titleView = starButton
    
    var controls: QuestionControlsViewController?
    for child in childViewControllers {
      if let controlsViewController = child as? QuestionControlsViewController {
        controls = controlsViewController
      }
    }
    
    if let controls = controls {
      let statViewController = storyboard!.instantiateViewControllerWithIdentifier("resultsViewController") as! QuestionResultsViewController
      statViewController.question = question
      statViewController.view.frame = controls.view.frame
      
      controls.willMoveToParentViewController(nil)
      addChildViewController(statViewController)
      let duration = animated ? 0.7 : 0
      transitionFromViewController(controls, toViewController: statViewController,
          duration: duration,
          options: .TransitionFlipFromRight, animations: nil)
        { (finished) -> Void in
            controls.removeFromParentViewController()
            statViewController.didMoveToParentViewController(self)
      }
    }
  }
}

extension QuestionViewController: QuestionControlsDelegate {
  
  func didAnswerTheQuestion() {
    print(question.state)
    NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
    delegate?.didAnswerTheQuestion?()
    showResults(true)
  }
}
