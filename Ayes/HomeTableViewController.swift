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
  
  override func viewDidLoad() {
    super.viewDidLoad()
   
    if ServerManager.sharedInstance.apiToken == nil {
      if let token = NSUserDefaults.standardUserDefaults().objectForKey("apiToken") as? String {
        ServerManager.sharedInstance.apiToken = token
      } else if let onboarding = UIStoryboard(name: "Onboarding", bundle: nil).instantiateInitialViewController() {
          navigationController?.presentViewController(onboarding, animated: false, completion: nil)
      }
    }
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      view.addGestureRecognizer(revealViewController.tapGestureRecognizer())
      revealViewController.delegate = self
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Questions")
    
    tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil),
        forCellReuseIdentifier: "questionCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = CGFloat(100)
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.separatorStyle =  .None
    tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 8))
    let backItem = UIBarButtonItem(title: LocalizeHelper.localizeStringForKey("Back"), style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
   
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:",
        forControlEvents: .ValueChanged)

    questions = Question.findAll() as! [Question]
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh:", name: QuestionsUpdateNotification, object: nil)
    
    if let navBarSubviews = navigationController?.navigationBar.subviews {
      for v in navBarSubviews {
        v.exclusiveTouch = true
      }
    }
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
      if let questions = questions {
        self.questions = questions
      }
    }
  }

  // MARK: UITableViewDataSource
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as? QuestionTableViewCell else {
      return UITableViewCell()
    }
    
    let question = questions[indexPath.row]
    cell.idLabel.text = "\(question.id ?? 0)"
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
    cell.dateLabel.text = dateFormatter.stringFromDate(question.dateCreated ?? NSDate())
    cell.contentTextView.text = question.content
    cell.contentTextView.font = UIFont.systemFontOfSize(19)
    cell.questionStateIndicator.backgroundColor = question.state.getAccentColor()
    switch question.state {
    case .Skip:
      cell.questionStatusLabel.text = LocalizeHelper.localizeStringForKey("Skipped")
      cell.questionStatusLabel.textColor = UIColor.blackColor()
    case .NoAnswer:
      cell.questionStatusLabel.text = LocalizeHelper.localizeStringForKey("New")
      cell.questionStatusLabel.textColor = UIColor.blueAccentColor()
    default:
      cell.questionStatusLabel.text = LocalizeHelper.localizeStringForKey("Answered")
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

//MARK: - SWRevealViewControllerDelegate

extension HomeTableViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
}
