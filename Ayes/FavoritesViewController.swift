//
//  FavoritesViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
  
  @IBOutlet weak var noContentLabel: UILabel!
  @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var noContentView: UIView!
  
  var questions = [Question]()
  
  override func viewDidLoad() {
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      revealViewController.rearViewRevealWidth = SIDE_BAR_WIDTH
    }
    
    navigationItem.title = LocalizeHelper.localizeStringForKey("Favorites")
    updateData()
    
    tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = CGFloat(100)
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.tableFooterView = nil
    tableView.separatorStyle = .None
    
    noContentLabel.text = LocalizeHelper.localizeStringForKey("Your favorite questions will appear right here.")
    noContentView.backgroundColor = UIColor.lightGreenBackgroundColor()
  }
  
  func updateData() {
    let allQuestions = Question.findAll() as! [Question]
    questions = allQuestions.filter { return $0.favorite }
  }
  
  //MARK: - Navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if let destination = segue.destinationViewController as? QuestionViewController,
      question = sender as? Question where segue.identifier == "questionInfo" {
        destination.question = question
        destination.delegate = self
    }
  }
}

//MARK: - QuestionChangesDelegate
extension FavoritesViewController: QuestionChangesDelegate {
  func didFavoriteTheQuestion(question: Question) {
    updateData()
    tableView.reloadData()
  }
}

//MARK: - UITableViewDataSource
extension FavoritesViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if questions.count == 0 {
      tableView.hidden = true
    } else {
      tableView.hidden = false
    }
    return questions.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("questionCell", forIndexPath: indexPath) as? QuestionTableViewCell else {
      return UITableViewCell()
    }
    
    let question = questions[indexPath.row]
    cell.idLabel.text = "\(question.id ?? 0)"
    cell.dateLabel.text = ""
    cell.contentTextView.text = question.content
    cell.contentTextView.font = UIFont.systemFontOfSize(18)
    cell.questionStateIndicator.backgroundColor = question.state.getAccentColor()
    cell.questionIndicatorIcon.image = UIImage(named: "FavoriteBlack")
    
    switch question.state {
    case .NoAnswer, .Skip:
      cell.questionStatusLabel.text = "Новый"
      cell.questionStatusLabel.textColor = UIColor.blueAccentColor()
    default:
      cell.questionStatusLabel.text = "Вы ответили"
      cell.questionStatusLabel.textColor = UIColor.blackColor()
    }
    
    return cell
  }
}

//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("questionInfo", sender: questions[indexPath.row])
  }
}
