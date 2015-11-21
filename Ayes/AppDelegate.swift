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

let sideBarWidth: CGFloat = 101
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
    
    UIBarButtonItem.appearance().setTitleTextAttributes( [NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 18)!], forState: .Normal)
    
    return true
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  func networkChanged(notification: NSNotification) {
    let remoteHostStatus = reachability.currentReachabilityStatus()
    switch remoteHostStatus {
    case ReachableViaWWAN, ReachableViaWiFi:
      
      // Favorites
      let favorites = Favorite.findByAttribute("sentToServer", withValue: false) as! [Favorite]
      for fav in favorites {
        ServerManager.sharedInstance.submitFavorite(fav) { (success) -> Void in
          if success {
            fav.sentToServer = true
          }
        }
      }
      
      // Answers 
      let answers = Answer.findByAttribute("sentToServer", withValue: false) as! [Answer]
      answers.forEach { (answer) -> () in
        ServerManager.sharedInstance.submitAnswer(answer) { (success) -> Void in
          if success {
            answer.sentToServer = true
          }
        }
      }
    default:
      break
    }
  }
  
  func loadAPIToken() {
    if let token = NSUserDefaults.standardUserDefaults().objectForKey("apiToken") as? String {
      ServerManager.sharedInstance.apiToken = token
      loadDeviceToken()
    } else {
      NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
//      ServerManager.sharedInstance.createUser { (success) -> Void in
//        if success {
//          NSUserDefaults.standardUserDefaults().setObject(ServerManager.sharedInstance.apiToken!, forKey: "apiToken")
//          NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
//        }
//      }
    }
  }
  
  func loadDeviceToken() {
    guard let token = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String else {
      UIApplication.sharedApplication().registerUserNotificationSettings(
        UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
      )
      UIApplication.sharedApplication().registerForRemoteNotifications()
      return
    }
    
    ServerManager.sharedInstance.deviceToken = token
    
//    ServerManager.sharedInstance.updateDeviceToken(token)
  }
  
  private func setUpNavigationBar() {
    UINavigationBar.appearance().barTintColor = UIColor.darkVioletPrimaryColor()
    UINavigationBar.appearance().translucent = false
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "Roboto-Regular", size: 18)!]
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
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
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    NSNotificationCenter.defaultCenter().postNotificationName(QuestionsUpdateNotification, object: nil)
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    UserManager.sharedManager.saveToUserDefaults()
    Settings.saveToUserDefaults()
  }
  
  //MARK - Push notifications
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
    var token = ""
    
    for var i = 0; i < deviceToken.length; i++ {
      token += String(format: "%02.2hhx", arguments: [tokenChars[i]])
    }
    
    NSUserDefaults.standardUserDefaults().setObject(token, forKey: "deviceToken")
    ServerManager.sharedInstance.deviceToken = token
    ServerManager.sharedInstance.updateDeviceToken(token)
  }
  
  func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
    // develper.layOnTheFloor()
    // do {
    //    try developer.notToCry()
    // catch {
    //    developer.cryALot()
    // }
  }
}

