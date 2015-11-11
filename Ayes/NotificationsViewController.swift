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
  @IBOutlet weak var skipButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    allowButton.layer.cornerRadius = 5
    allowButton.layer.borderWidth = 3
    allowButton.layer.borderColor = UIColor.greenAccentColor().CGColor
    view.backgroundColor = UIColor.darkVioletPrimaryColor()
  }
  
  //MARK - IBActions
  
  @IBAction func allowButtonAction(sender: AnyObject) {
    UIApplication.sharedApplication()
        .registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        )
    
    UIApplication.sharedApplication().registerForRemoteNotifications()
    view.userInteractionEnabled = false
  }
  
  @IBAction func skipButtonAction(sender: AnyObject) {
    NSNotificationCenter.defaultCenter().postNotificationName(OnboardingGoToFinalPageNotification, object: nil)
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