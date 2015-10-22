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
  let refreshDataControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.delegate = self
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Questions")
    
    tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil),
        forCellReuseIdentifier: "questionCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = CGFloat(100)
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.separatorStyle =  .None
    let backItem = UIBarButtonItem(title: LocalizeHelper.localizeStringForKey("Back"), style: .Plain, target: nil, action: nil)
    navigationItem.backBarButtonItem = backItem
    
    refreshDataControl.addTarget(self, action: "refresh:",
        forControlEvents: .ValueChanged)
    tableView.addSubview(refreshDataControl)

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
      self.refreshDataControl.endRefreshing()
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
    cell.contentTextView.font = UIFont.systemFontOfSize(18)
    cell.questionStateIndicator.backgroundColor = question.state.getAccentColor()
    switch question.state {
    case .Skip:
      cell.questionStatusLabel.text = "Вы пропустили"
      cell.questionStatusLabel.textColor = UIColor.blackColor()
    case .NoAnswer:
      cell.questionStatusLabel.text = "Новый"
      cell.questionStatusLabel.textColor = UIColor.blueAccentColor()
    default:
      cell.questionStatusLabel.text = "Вы ответили"
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
