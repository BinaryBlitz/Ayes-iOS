//
//  User.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@objc class User: NSObject, NSCoding {
  
  static private(set) var sharedInstance = User()
  
  override init() {
    super.init()
  }
  
  internal required init(coder aDecoder: NSCoder) {
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
  }
  
  static func saveToUserDefaults() {
    let userData = NSKeyedArchiver.archivedDataWithRootObject(sharedInstance)
    NSUserDefaults.standardUserDefaults().setObject(userData, forKey: "ayesUser")
  }
  
  static func loadFromUserDefaults() {
    if let userData = NSUserDefaults.standardUserDefaults().objectForKey("ayesUser") as? NSData {
      if let user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? User {
        sharedInstance = user
      }
    } else {
      saveToUserDefaults()
    }
  }
}