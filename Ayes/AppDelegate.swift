//
//  AppDelegate.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 05/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit
import MagicalRecord

let SIDE_BAR_WIDTH: CGFloat = 100

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    MagicalRecord.setupAutoMigratingCoreDataStack()
    MagicalRecord.enableShorthandMethods()
    setUpNavigationBar()
    addSampleQuestions()
    return true
  }
  
  private func setUpNavigationBar() {
    UINavigationBar.appearance().barTintColor = UIColor.violetPrimaryColor()
    UINavigationBar.appearance().translucent = false
    UINavigationBar.appearance().tintColor = UIColor.whiteColor()
    UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
    UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
  }
  
  func addSampleQuestions() {
    let q1 = Question.MR_createEntity()
    q1.content = "Ходили ли вы за это месяц хотя бы раз на свидание?"
    q1.id = 2301
    q1.dateCreated = NSDate()
    
    let q2 = Question.MR_createEntity()
    q2.content = "Умеете ли Вы плавать?"
    q2.id = 2305
    q2.dateCreated = NSDate()
    q2.state = .No
    
    let q3 = Question.MR_createEntity()
    q3.content = "очень очень очень очень очень очень очень очень очень очень очень очень очень очень длинный тест, чтобы проверить динамическую высоту"
    q3.id = 2305
    q3.dateCreated = NSDate()
    q3.state = .Yes
    
    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

