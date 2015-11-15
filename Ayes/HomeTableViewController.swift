//
//  HomeTableViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  var questions = [Question]() {
    didSet {
      questions.sortInPlace { (q1, q2) -> Bool in
        return q1.dateCreated?.compare(q2.dateCreated ?? NSDate()) == .OrderedDescending && (q1.id ?? 0) > (q2.id ?? 0)
      }
    }
  }
  
  var gesturesView = UIView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    let onboardingMark = NSUserDefaults.standardUserDefaults().objectForKey("onboarding") as? String
    if let onboarding = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController()
        where onboardingMark == nil {
        navigationController?.presentViewController(onboarding, animated: false, completion: nil)
    }
    
    // Side Bar Gestures
    
    gesturesView.frame = tableView.frame
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      gesturesView.addGestureRecognizer(revealViewController.tapGestureRecognizer())
      gesturesView.addGestureRecognizer(revealViewController.panGestureRecognizer())
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    navigationItem.title = "Questions".localize()
    
    // TableView
    
    tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil),
        forCellReuseIdentifier: "questionCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = CGFloat(100)
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.separatorStyle =  .None
    tableView.tableHeaderView = UIView(frame:
      CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8)
    )
    
    // Navigation bar
    
    let backItem = UIBarButtonItem(title: "Back".localize(),
        style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
    if let navBarSubviews = navigationController?.navigationBar.subviews {
      for v in navBarSubviews {
        v.exclusiveTouch = true
      }
    }
    
    // Refresh
    
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:",
        forControlEvents: .ValueChanged)

    // Load questions
    
    questions = Question.findAll() as! [Question]

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh:",
        name: QuestionsUpdateNotification, object: nil)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  //MARK: - Refresh
  func refresh(sender: AnyObject) {
    refreshBegin {
      self.refreshControl?.endRefreshing()
      self.tableView.reloadData()
    }
  }

  func refreshBegin(refreshEnd: () -> Void) {
    ServerManager.sharedInstance.getQuestions { (questions) -> Void in
      defer { refreshEnd() }
      if let _ = questions {
        self.questions = Question.findAll() as! [Question]
      }
    }
  }

  // MARK: UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("questionCell") as? QuestionTableViewCell else {
      return UITableViewCell()
    }
    
    let question = questions[indexPath.row]
    cell.idLabel.text = "\(question.id ?? 0)"
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    cell.dateLabel.text = dateFormatter.stringFromDate(question.dateCreated ?? NSDate())
    cell.contentTextView.text = question.content
    cell.contentTextView.font = UIFont(name: "Roboto-Regular", size: 19)
    cell.questionStateIndicator.backgroundColor = question.state.getAccentColor()
    switch question.state {
    case .Skip:
      cell.questionStatusLabel.text = "Skipped".localize()
      cell.questionStatusLabel.textColor = UIColor.blackColor()
    case .NoAnswer:
      cell.questionStatusLabel.text = "New".localize()
      cell.questionStatusLabel.textColor = UIColor.blueAccentColor()
    default:
      cell.questionStatusLabel.text = "Answered".localize()
      cell.questionStatusLabel.textColor = UIColor.blackColor()
    }
    
    return cell
  }
  
  //MARK: - UITableViewDelegate
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("showQuestion", sender: questions[indexPath.row])
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
  }
  
  //MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let question = sender as? Question where segue.identifier == "showQuestion" {
      let destination = segue.destinationViewController as! QuestionViewController
      destination.delegate = self
      destination.question = question
    }
  }
}

//MARK: - QuestionChangesDelegate

extension HomeTableViewController: QuestionChangesDelegate {
  
  func didAnswerTheQuestion(question: Question) {
    tableView.reloadData()
  }
}

extension HomeTableViewController: SWRevealViewControllerDelegate {
  
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    if position == .Left {
      gesturesView.removeFromSuperview()
      tableView.scrollEnabled = true
    } else {
      view.addSubview(gesturesView)
      tableView.scrollEnabled = false
    }
  }
}