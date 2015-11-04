//
//  AppDelegate.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 05/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import MagicalRecord
import Fabric
import Crashlytics

let sideBarWidth: CGFloat = 100
var sideBarButtonsWidth: CGFloat = 100
let QuestionsUpdateNotification = "QuestionsUpdateNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var reachability: Reachability!

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    MagicalRecord.setupAutoMigratingCoreDataStack()
    MagicalRecord.enableShorthandMethods()
    Settings.loadFromUserDefaults()
    UserManager.sharedManager.loadFromUserDefaults()
    LocalizeHelper.setLanguage(Settings.sharedInstance.language ?? "ru")
    Fabric.with([Crashlytics.self])
    setUpNavigationBar()
    UIApplication.sharedApplication().statusBarHidden = false
    if UIScreen.mainScreen().bounds.height == 480 {
      sideBarButtonsWidth = 80
    }
    
    loadAPIToken()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "networkChanged:", name: kReachabilityChangedNotification, object: nil)
    reachability = Reachability.reachabilityForInternetConnection()
    reachability.startNotifier()
    
    UIApplication.sharedApplication()
        .registerUserNotificationSettings(
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        )
    UIApplication.sharedApplication().registerForRemoteNotifications()
    
    return true
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func networkChanged(notification: NSNotification) {
    let remoteHostStatus = reachability.currentReachabilityStatus()
    switch remoteHostStatus {
    case NotReachable:
      print("ooops")
    case ReachableViaWWAN:
      print("wwan")
    default:
      print("other stuff")
    }
  }
  
  func loadAPIToken() {
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("apiToken") as? String {
      ServerManager.sharedInstance.apiToken = token
    } else {
      ServerManager.sharedInstance.createUser { (success) -> Void in
        if success {
          NSUserDefaults.standardUserDefaults().setObject(ServerManager.sharedInstance.apiToken!, forKey: "apiToken")
          NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
        }
      }
    }
  }
  
  private func setUpNavigationBar() {
    UINavigationBar.appearance().barTintColor = UIColor.darkVioletPrimaryColor()
    UINavigationBar.appearance().translucent = false
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
  }
  
  func addSampleQuestions() {
    let questions = Question.findAll()
    for q in questions {
      q.MR_deleteEntity()
    }
    let q1 = Question.MR_createEntity()
    q1.content = "Ходили ли вы за это месяц хотя бы раз на свидание?"
    q1.id = 2301
    q1.dateCreated = NSDate()
    q1.yesAnswers = 70
    q1.noAnswers = 30
    q1.totalAnswers = 120
    
    let q2 = Question.MR_createEntity()
    q2.content = "Умеете ли Вы плавать?"
    q2.id = 2305
    q2.dateCreated = NSDate()
    q2.yesAnswers = 40
    q2.noAnswers = 15
    q2.totalAnswers = 80
    
    let q3 = Question.MR_createEntity()
    q3.content = "Вы выбрасываете мусор в окно?"
    q3.id = 2306
    q3.dateCreated = NSDate()
    q3.yesAnswers = 80
    q3.noAnswers = 30
    q3.totalAnswers = 150
    
    let q4 = Question.MR_createEntity()
    q4.content = "Вы давно последний раз меняли телефон?"
    q4.id = 2390
    q4.dateCreated = NSDate()
    q4.yesAnswers = 80
    q4.noAnswers = 90
    q4.totalAnswers = 200
    
    let q5 = Question.MR_createEntity()
    q5.content = "Вам нарвится новый iPhone?"
    q5.id = 2400
    q5.dateCreated = NSDate()
    q5.yesAnswers = 500
    q5.noAnswers = 120
    q5.totalAnswers = 700
    
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    UserManager.sharedManager.saveToUserDefaults()
    Settings.saveToUserDefaults()
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UserManager.sharedManager.saveToUserDefaults()
    Settings.saveToUserDefaults()
  }
  
  //MARK - Push notifications
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    print(deviceToken)
  }
}

