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
  @IBOutlet weak var questionWithResultsView: UIView!
  
  var question: Question!
  weak var delegate: QuestionChangesDelegate?
  var statDelegate: StatDataDisplay?
  
  var statType: StatType = .Normal

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
    
    if let navBarSubviews = navigationController?.navigationBar.subviews {
      for v in navBarSubviews {
        v.exclusiveTouch = true
      }
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
    guard let question = question, content = question.content else {
      return
    }
    
    let viewToShare = questionWithResultsView
    viewToShare.backgroundColor = UIColor.violetPrimaryColor()
    let image = UIView.imageWithView(viewToShare)
    let post = "\(content) #ayes"
    let activityController = UIActivityViewController(activityItems: [post, image], applicationActivities: nil)
    presentViewController(activityController, animated: true, completion: nil)
  }
  
  func favoriteButtonAction(sender: AnyObject) {
    if let starButton = navigationItem.titleView as? UIButton {
      starButton.selected = !starButton.selected
      question.isFavorite = NSNumber(bool: starButton.selected)
      if let favoriteObject = Favorite.createWithQuestion(question) {
        ServerManager.sharedInstance.submitFavorite(favoriteObject) { (success) -> Void in
          if success {
            favoriteObject.MR_deleteEntity()
            NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
          }
        }
      }
      
      NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
      delegate?.didFavoriteTheQuestion?(question)
    }
  }
  
  @IBAction func sameAsMeButtonAction(sender: AnyObject) {
    guard let user = UserManager.sharedManager.user else {
      return
    }
    
    if statType == .Similar {
      sameAsMeButton.setTitle(LocalizeHelper.localizeStringForKey("Same as me"), forState: .Normal)
      statType = .Normal
      statDelegate?.didChangeStatType(StatType.Normal)
      return
    }
    
    if user.isAllFieldsFilled() {
      let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
      indicator.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
      indicator.layer.cornerRadius = 3
      indicator.backgroundColor = UIColor.darkVioletPrimaryColor()
      indicator.center = view.center
      indicator.center.y -= 120
      view.addSubview(indicator)
      view.bringSubviewToFront(indicator)
      
      indicator.startAnimating()
      ServerManager.sharedInstance.getSimilarAnswersForQuestion(question) { (stat) in
        indicator.stopAnimating()
        if let stat = stat {
          self.question.similarStat = stat
          NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
          self.statType = .Similar
          self.sameAsMeButton.setTitle(LocalizeHelper.localizeStringForKey("All"), forState: .Normal)
          self.statDelegate?.didChangeStatType(StatType.Similar)
        } else {
          let alert = UIAlertController(title: nil, message: LocalizeHelper.localizeStringForKey("No internet connection"), preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }
      
    } else {
      let alert = UIAlertController(title: LocalizeHelper.localizeStringForKey("Questionnaire"), message: LocalizeHelper.localizeStringForKey("notFilledAlert"), preferredStyle: .Alert)
      alert.addAction(
        UIAlertAction(title: LocalizeHelper.localizeStringForKey("Cancel"), style: .Default, handler: nil)
      )
      
      alert.addAction(
        UIAlertAction(title: LocalizeHelper.localizeStringForKey("Fix now"),
          style: .Cancel,
          handler: { (_) -> Void in
            let storyboard = UIStoryboard(name: "Questionnaire", bundle: nil)
            if let navigation = storyboard.instantiateInitialViewController() as? UINavigationController {
              let questionnaireController  = navigation.viewControllers.first as! QuestionnaireTableViewController
              questionnaireController.style = .Modal
              self.presentViewController(navigation, animated: true, completion: nil)
            }
      }))
      
      presentViewController(alert, animated: true, completion: nil)
    }
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Share"),
        style: .Plain, target: self, action: "shareButtonAction:")
    let starButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 90))
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
      statDelegate = statViewController
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

extension QuestionViewController: QuestionChangesDelegate {
  
  func didAnswerTheQuestion(question: Question) {
    print(question.state)
    NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
    delegate?.didAnswerTheQuestion?(question)
    showResults(true)
  }
}
