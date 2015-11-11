//
//  FinalViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class FinalViewController: UIViewController {

  private var _index = 0
  @IBOutlet weak var startButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    startButton.layer.cornerRadius = 5
    startButton.layer.borderWidth = 3
    startButton.layer.borderColor = UIColor.greenAccentColor().CGColor
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
  }
  
  @IBAction func startButtonAction(sender: AnyObject) {
    
    UIApplication.sharedApplication()
        .registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        )
    UIApplication.sharedApplication().registerForRemoteNotifications()

    let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
    indicator.frame = CGRect(x: 0.0, y: 0.0, width: 70.0, height: 70.0)
    indicator.layer.cornerRadius = 3
    indicator.backgroundColor = UIColor.darkVioletPrimaryColor()
    indicator.center = view.center
    view.addSubview(indicator)
    view.bringSubviewToFront(indicator)
    
    indicator.startAnimating()
    
    // get api token
    ServerManager.sharedInstance.createUser { (success) -> Void in
      if success {
        NSUserDefaults.standardUserDefaults().setObject(ServerManager.sharedInstance.apiToken!, forKey: "apiToken")
        
        // Get questions
        ServerManager.sharedInstance.getQuestions { (questions) -> Void in
          indicator.stopAnimating()
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

extension FinalViewController: OnboardingPageContent {
  
  var index: Int {
    get {
      return _index
    }
    set {
      _index = newValue
    }
  }
}
