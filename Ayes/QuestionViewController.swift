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
  @IBOutlet weak var questionContentLabel: UILabel!
  @IBOutlet weak var questionDateLabel: UILabel!
  @IBOutlet weak var questionIdLabel: UILabel!
  @IBOutlet weak var questionWithResultsView: UIView!

  @IBOutlet var separationLineHeightConstraints: [NSLayoutConstraint]!

  var question: Question!
  weak var delegate: QuestionChangesDelegate?
  var statDelegate: StatDataDisplay?

  var statType: StatType = .Normal

  override func viewDidLoad() {
    super.viewDidLoad()

    separationLineHeightConstraints.forEach {
      (heightConstraint) in
      heightConstraint.constant = 1 / UIScreen.mainScreen().scale
    }

    view.backgroundColor = UIColor.violetPrimaryColor()

    if let content = question.content {
      if let epigraph = question.epigraph where epigraph != "" {
        let format = "%@\n\n%@"
        let formattedString = String(format: format, epigraph, content)
        let attributedString = NSMutableAttributedString(string: formattedString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-LightItalic", size: 25)!, range: (formattedString as NSString).rangeOfString(epigraph))

        questionContentLabel.attributedText = attributedString
      } else {
        questionContentLabel.text = content
      }
    }


    let formatter = NSDateFormatter()
    formatter.dateFormat = "dd.MM.yyyy"
    questionDateLabel.text = formatter.stringFromDate(question.publishedAt ?? NSDate())

    questionIdLabel.text = "\(question.id ?? 0)"
    warningLabel.text = "SkipWarning".localize()

    otherUsersButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    otherUsersButton.setTitle("Other users".localize(), forState: .Normal)

    otherUsersButton.hidden = true

    sameAsMeButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    sameAsMeButton.setTitle("Same as me".localize(), forState: .Normal)
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
    } else if let destinationNavController = segue.destinationViewController as? UINavigationController,
    destination = destinationNavController.viewControllers.first as? CreateFormsTableViewController {
      destination.question = question
      destination.statDelegate = statDelegate
      destination.delegate = self
    }
  }

  func shareButtonAction(sender: AnyObject) {
    guard let question = question, content = question.content else {
      return
    }

    let viewToShare = questionWithResultsView
    viewToShare.backgroundColor = UIColor.violetPrimaryColor()


    // load special controller for image
    let questionResultController = storyboard!.instantiateViewControllerWithIdentifier("ShareCardViewController") as! ShareCardViewController

    // magic is happening here
    questionResultController.view.frame = CGRect(x: 0, y: 0, width: 360, height: 400)
    questionResultController.view.layer.frame = CGRect(x: 0, y: 0, width: 360, height: 400)
    
    questionResultController.view.backgroundColor = UIColor.violetPrimaryColor()
    addChildViewController(questionResultController)
    questionResultController.didMoveToParentViewController(self)
    questionResultController.configureWithQuestion(question, andStatType: statType)

    //create image and content
    let image = UIView.imageWithView(questionResultController.view)
    let post = "\(content) #ayes"
    let activityController = UIActivityViewController(activityItems: [post, image], applicationActivities: nil)
    presentViewController(activityController, animated: true, completion: nil)
    questionResultController.removeFromParentViewController()
  }

  func favoriteButtonAction(sender: AnyObject) {
    if let starButton = navigationItem.titleView as? UIButton {
      starButton.selected = !starButton.selected
      question.isFavorite = NSNumber(bool: starButton.selected)
      if let favoriteObject = Favorite.createWithQuestion(question) {
        ServerManager.sharedInstance.submitFavorite(favoriteObject) {
          (success) -> Void in
          if success {
            favoriteObject.sentToServer = true
            NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
          }
        }
        NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
      }

      delegate?.didFavoriteTheQuestion?(question)
    }
  }

  @IBAction func otherUsersButtonAction(sender: AnyObject) {
    performSegueWithIdentifier("createForms", sender: nil)
  }

  @IBAction func sameAsMeButtonAction(sender: AnyObject) {
    guard let user = UserManager.sharedManager.user else {
      return
    }

    switch statType {
    case .Similar:
      sameAsMeButton.setTitle("Same as me".localize(), forState: .Normal)
      statType = .Normal
      statDelegate?.didChangeStatType(StatType.Normal)
      return
    default:
      break
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
      ServerManager.sharedInstance.getSimilarAnswersForQuestion(question) {
        (stat) in
        indicator.stopAnimating()
        if let stat = stat {
          self.question.similarStat = stat
          NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
          self.statType = .Similar
          self.sameAsMeButton.setTitle("All".localize(), forState: .Normal)
          self.statDelegate?.didChangeStatType(StatType.Similar)
        } else {
          let alert = UIAlertController(title: nil, message: "Error! Try again later.".localize(), preferredStyle: .Alert)
          alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
          self.presentViewController(alert, animated: true, completion: nil)
        }
      }

    } else {
      let alert = UIAlertController(title: "Questionnaire".localize(), message: "notFilledAlert".localize(), preferredStyle: .Alert)
      alert.addAction(
      UIAlertAction(title: "Cancel".localize(), style: .Default, handler: nil)
      )

      alert.addAction(
      UIAlertAction(title: "Fix now".localize(),
              style: .Cancel,
              handler: {
                (_) -> Void in
                let storyboard = UIStoryboard(name: "Questionnaire", bundle: nil)
                if let navigation = storyboard.instantiateInitialViewController() as? UINavigationController {
                  let questionnaireController = navigation.viewControllers.first as! QuestionnaireTableViewController
                  questionnaireController.style = .Modal
                  self.presentViewController(navigation, animated: true, completion: nil)
                }
              }))

      presentViewController(alert, animated: true, completion: nil)
    }
  }

  func showResults(animated: Bool) {
    UIView.animateWithDuration(animated ? 0.7 : 0) {
      () -> Void in
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
              options: .TransitionFlipFromRight, animations: nil) {
        (finished) -> Void in
        controls.removeFromParentViewController()
        statViewController.didMoveToParentViewController(self)
      }
    }
  }
}

extension QuestionViewController: QuestionChangesDelegate {

  func didAnswerTheQuestion(question: Question) {
    NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
    delegate?.didAnswerTheQuestion?(question)
    showResults(true)
  }
}

extension QuestionViewController: CreateFormsDelegate {
  func didUpdateStat() {
    statType = .Similar
    sameAsMeButton.setTitle("All".localize(), forState: .Normal)
  }
}
