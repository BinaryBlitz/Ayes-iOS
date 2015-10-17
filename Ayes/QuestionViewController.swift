//
//  QuestionViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 14/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
  
  @IBOutlet weak var sameAsMeButton: UIButton!
  @IBOutlet weak var otherUsersButton: UIButton!
  @IBOutlet weak var controlsContainer: UIView!
  @IBOutlet weak var warningLabel: UILabel!
  @IBOutlet weak var warningIcon: UIImageView!
  @IBOutlet weak var contentTextView: ResizableTextView!
  @IBOutlet weak var questionDateLabel: UILabel!
  @IBOutlet weak var questionIdLabel: UILabel!
  
  var question: Question!
  var delegate: QuestionControlsDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.violetPrimaryColor()
    contentTextView.minimumFontSizeInPoints = 5
    contentTextView.maximumFontSizeInPoints = 25
    contentTextView.text = question.content!
    
    if UIScreen.mainScreen().bounds.height == 480
      && question.content?.characters.count >= 190 {
        contentTextView.font = UIFont.systemFontOfSize(13)
    } else if UIScreen.mainScreen().bounds.height == 568 {
      if question.content?.characters.count > 210 {
        contentTextView.font = UIFont.systemFontOfSize(14)
      } else if question.content?.characters.count > 190 {
        contentTextView.font = UIFont.systemFontOfSize(15)
      }
    }
    
    contentTextView.userInteractionEnabled  = false
    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    questionDateLabel.text = formatter.stringFromDate(question.dateCreated ?? NSDate())
    
    questionIdLabel.text = "\(question.id ?? 0)"
    warningLabel.text = LocalizeHelper.localizeStringForKey("SkipWarning")
    
    otherUsersButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    otherUsersButton.setTitle(LocalizeHelper.localizeStringForKey("Other users"), forState: .Normal)
    
    otherUsersButton.hidden = true
    
    sameAsMeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    sameAsMeButton.setTitle(LocalizeHelper.localizeStringForKey("Same as me"), forState: .Normal)
    sameAsMeButton.hidden = true
    
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
      question.isFavorite = NSNumber(bool: starButton.selected)
    }
  }
  
  @IBAction func sameAsMeButtonAction(sender: AnyObject) {
    
  }
  
  @IBAction func otherUsersButtonAction(sender: AnyObject) {
   let alert = UIAlertController(title: nil, message: LocalizeHelper.localizeStringForKey("This function will be paid soon!"), preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "ОК", style: .Default, handler: nil))
    presentViewController(alert, animated: true, completion: nil)
  }
  
  func showResults(animated: Bool) {
    UIView.animateWithDuration(animated ? 0.7 : 0) { () -> Void in
      self.warningIcon.hidden = true
      self.warningLabel.hidden = true
      self.sameAsMeButton.hidden = false
      self.otherUsersButton.hidden = false
    }
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action, target: self, action: "shareButtonAction:")
    let starButton = UIButton(frame: CGRect(x: 0, y: 0, width: 70, height: 70))
    starButton.imageView?.image = UIImage(named: "Favorite")
    starButton.setImage(UIImage(named: "Favorite"), forState: .Normal)
    let filledImage = UIImage(named: "FavoriteFilled")
    starButton.setImage(filledImage, forState: UIControlState.Highlighted)
    starButton.setImage(filledImage, forState: UIControlState.Selected)
    starButton.addTarget(self, action: "favoriteButtonAction:", forControlEvents: .TouchUpInside)
    navigationItem.titleView = starButton
    starButton.selected = question.favorite
    
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
