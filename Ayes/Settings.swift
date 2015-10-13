//
//  Settings.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation

@objc class Settings: NSObject, NSCoding {
  
  static var sharedInstance = Settings()
  
  var language: String?
  var region: String?
  var questionTime: NSDate
  
  override init() {
    
    let systemLanguages = NSLocale.preferredLanguages()
    var flag = false
    for lang in systemLanguages {
      if flag {
        break
      }
      for availableLang in LocalizeHelper.sharedHelper.availableLanguages where lang.containsString(availableLang) {
        language = availableLang
        LocalizeHelper.setLanguage(language ?? "ru")
        flag = true
        break
      }
    }
    region = "russia" //?
    let dateComponents = NSCalendar.currentCalendar().components([.Minute, .Hour], fromDate: NSDate())
    dateComponents.hour = 19
    dateComponents.minute = 0
    questionTime = NSCalendar.currentCalendar().dateFromComponents(dateComponents) ?? NSDate()
    super.init()
  }
  
  internal required init(coder aDecoder: NSCoder) {
    language = aDecoder.decodeObjectForKey("ayesLanguage") as? String
    LocalizeHelper.setLanguage(language ?? "ru")
    region = aDecoder.decodeObjectForKey("ayesRegion") as? String
    questionTime = aDecoder.decodeObjectForKey("ayesQuestionTime") as! NSDate
  }
  
  func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(language, forKey: "ayesLanguage")
    aCoder.encodeObject(region, forKey: "ayesRegion")
    aCoder.encodeObject(questionTime, forKey: "ayesQuestionTime")
  }
  
  static func saveToUserDefaults() {
    let settingsData = NSKeyedArchiver.archivedDataWithRootObject(sharedInstance)
    NSUserDefaults.standardUserDefaults().setObject(settingsData, forKey: "ayesSettings")
  }
  
  static func loadFromUserDefaults() {
    if let settingsData = NSUserDefaults.standardUserDefaults().objectForKey("ayesSettings") as? NSData {
      if let settings = NSKeyedUnarchiver.unarchiveObjectWithData(settingsData) as? Settings {
        sharedInstance = settings
      }
    } else {
      saveToUserDefaults()
    }
  }
}