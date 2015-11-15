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
  
  var isDeletingCell = false
  
  override func viewDidLoad() {
    
    if let revealViewController = revealViewController() {
      menuBarButtonItem.target = revealViewController
      menuBarButtonItem.action = "revealToggle:"
      view.addGestureRecognizer(revealViewController.panGestureRecognizer())
      view.addGestureRecognizer(revealViewController.tapGestureRecognizer())
      revealViewController.delegate = self
    }
    
    navigationItem.title = "Favorites".localize()
    updateData()
    
    tableView.registerNib(UINib(nibName: "QuestionTableViewCell", bundle: nil), forCellReuseIdentifier: "questionCell")
    tableView.rowHeight = UITableViewAutomaticDimension
    tableView.estimatedRowHeight = CGFloat(100)
    tableView.backgroundColor = UIColor.lightGreenBackgroundColor()
    tableView.tableFooterView = nil
    tableView.separatorStyle = .None
    
    noContentLabel.text = "Your favorite questions will appear right here.".localize()
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
    cell.contentTextView.font = UIFont(name: "Roboto-Regular", size: 18)
    cell.questionStateIndicator.backgroundColor = question.state.getAccentColor()
    cell.questionIndicatorIcon.image = UIImage(named: "FavoriteBlack")
    
//    let bucketView = UIImageView(image: UIImage(named: "Trash"))
//    bucketView.contentMode = .Center
    
    let deleteButton = UIButton(type: .Custom)
    deleteButton.backgroundColor = UIColor.lightGreenBackgroundColor()
    deleteButton.setImage(UIImage(named: "Trash"), forState: .Normal)
    deleteButton.imageView?.contentMode = .Center
    
    cell.addFirstButton(deleteButton, withWidth: 70) { (cellToDelete) -> Void in
      self.tableView.beginUpdates()
      if let indexPath = self.tableView.indexPathForCell(cellToDelete) {
        let question = self.questions[indexPath.row]
        question.isFavorite = nil
        self.questions.removeAtIndex(indexPath.row)
        if let id = question.id?.integerValue {
          if let favorite = Favorite.MR_findFirstByAttribute("question_id", withValue: id) {
            favorite.MR_deleteEntity()
            NSManagedObjectContext.defaultContext().MR_saveToPersistentStoreAndWait()
          }
        }
        
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
      }
      self.tableView.endUpdates()
    }
    
    cell.delegate = self
    
    cell.selectionStyle = .None
    
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
}

//MARK: - UITableViewDelegate
extension FavoritesViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("questionInfo", sender: questions[indexPath.row])
  }
}

//MARK: - SWRevealViewControllerDelegate

extension FavoritesViewController: SWRevealViewControllerDelegate {
  func revealController(revealController: SWRevealViewController!, didMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
  
  func revealController(revealController: SWRevealViewController!, willMoveToPosition position: FrontViewPosition) {
    tableView.userInteractionEnabled = position == .Left
  }
}

extension FavoritesViewController: AFMSlidingCellDelegate {
  func shouldAllowShowingButtonsForCell(cell: AFMSlidingCell!) -> Bool {
   return !isDeletingCell
  }
  
  func buttonsDidShowForCell(cell: AFMSlidingCell!) {
    isDeletingCell = true
  }
  
  func buttonsDidHideForCell(cell: AFMSlidingCell!) {
    isDeletingCell = false
  }
}