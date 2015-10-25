//
//  LocalizeHelper.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 13/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation

class LocalizeHelper {
  static let sharedHelper = LocalizeHelper()
  private var myBundle: NSBundle
  var currentLanguage: String {
    return Settings.sharedInstance.language ?? ""
  }
  var availableLanguages = ["en", "ru"]
  
  init() {
    myBundle = NSBundle.mainBundle()
    
  }
  
  static func localizeStringForKey(key: String) -> String? {
   return sharedHelper.myBundle.localizedStringForKey(key, value: nil, table: nil)
  }
  
  static func setLanguage(lang: String) {
    print("Change to \(lang)")
    if !sharedHelper.availableLanguages.contains(lang) {
      fatalError("Language with identifire \(lang) is not available.")
    }
    
    if let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj") {
      if let bundle = NSBundle(path: path) {
        sharedHelper.myBundle = bundle
        return
      }
    }
    
    sharedHelper.myBundle = NSBundle.mainBundle()
  }
  
  static func getCurrentLanguage() -> String {
    return sharedHelper.currentLanguage
  }
}