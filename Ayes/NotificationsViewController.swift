//
//  NotificationsViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
  var _index: Int = 0
  
  @IBOutlet weak var allowButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
  }
  
  //MARK - IBActions
  
  @IBAction func allowButtonAction(sender: AnyObject) {
    
    let activityIndicator = createActivityIndicator()
    view.addSubview(activityIndicator)
    view.bringSubviewToFront(activityIndicator)
    
    activityIndicator.startAnimating()
    
    // Get api token
    ServerManager.sharedInstance.createUser { (success) -> Void in
      if success {
        NSUserDefaults.standardUserDefaults().setObject(ServerManager.sharedInstance.apiToken!, forKey: "apiToken")
        
        // Register for notifications
        self.registerForPushNotifications()
        
        // Get questions
        ServerManager.sharedInstance.getQuestions { (questions) -> Void in
          activityIndicator.stopAnimating()
          if questions != nil {
            NSUserDefaults.standardUserDefaults().setObject("stuff", forKey: "onboarding")
            NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
            self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
          } else {
            self.presentErrorAlert()
          }
        }
      } else {
        self.presentErrorAlert()
      }
    }
  }
  
  func createActivityIndicator() -> UIActivityIndicatorView {
    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    indicator.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
    indicator.layer.cornerRadius = 3
    indicator.backgroundColor = UIColor.darkVioletPrimaryColor()
    indicator.center = view.center
    
    return indicator
  }
  
  func registerForPushNotifications() {
    UIApplication.sharedApplication()
        .registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        )
    
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  func presentErrorAlert() {
    let alert = UIAlertController(
        title: "Ошибка",
        message: "Не удалось! Проверьте ваше интернет соединение.",
        preferredStyle: .Alert
    )
    
    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
  }
}


//MARK: - OnboardingPageContent

extension NotificationsViewController: OnboardingPageContent {
  var index: Int {
    get {
      return _index
    }
    set {
      _index = newValue
    }
  }
}