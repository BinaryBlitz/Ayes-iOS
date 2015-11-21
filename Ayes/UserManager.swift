//
//  UserManager.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 25/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

internal let kBirthDate = "birthdate"
internal let kSex = "gender"
internal let kRegion = "region"
internal let kLocality = "settlement"
internal let kCity = "city"
internal let kOccupation = "occupation"
internal let kIncome = "income"
internal let kEducation = "education"
internal let kRelationship = "relationship"

/// Helps to manage user model
class UserManager {
  
  static let sharedManager = UserManager()
  private let kUser = "ayesUser"
  
  var user: User? {
    didSet {
      saveToUserDefaults()
    }
  }
  
  var lastUpdate: NSDate? {
    get {
      return user?.lastUpdate
    }
    set {
      user?.lastUpdate = newValue
    }
  }
  var tmpUser: User?
  
  var avalableKeys: [String] {
    return [kBirthDate, kSex, kRegion, kLocality,
      kOccupation, kIncome, kEducation, kRelationship]
  }
  
  let dateFormatter: NSDateFormatter
  
  init() {
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
  }
  
  func dropTempUser() {
    tmpUser = nil
  }
  
  func canUpdateUser() -> Bool {
    if let lastUpdate = lastUpdate {
      let interval = lastUpdate.timeIntervalSinceNow
      return -interval > 7 * 24 * 60 * 60
    }
    
    if let tmp = tmpUser {
      tmp.isAllFieldsFilled()
      
      return true
    }
    
    return false
  }
  
  func updateUserIfPossible() -> Bool {
    if canUpdateUser() {
      user = tmpUser
      tmpUser = nil
      let currentDate = NSDate()
      let interval = (currentDate.timeIntervalSince1970 / 10000) * 10000
      lastUpdate = NSDate(timeIntervalSince1970: interval)
      saveToUserDefaults()
      return true
    }
    
    return false
  }
  
  func updateKey(key: String, withValue value: String) {
    guard let user = user else {
      return
    }
    
    if tmpUser == nil {
      tmpUser = user.copy() as? User
    }
    
    switch key {
    case kBirthDate:
      tmpUser?.birthDate = dateFormatter.dateFromString(value)
    case kSex:
      tmpUser?.sex = User.Sex(rawValue: value)
    case kRegion:
      tmpUser?.region = value
    case kLocality:
      tmpUser?.locality = User.Locality(rawValue: value)
    case kOccupation:
      tmpUser?.occupation = User.Occupation(rawValue: value)
    case kIncome:
      tmpUser?.income = User.Income(rawValue: value)
    case kEducation:
      tmpUser?.education = User.Education(rawValue: value)
    case kRelationship:
      tmpUser?.relationship = User.Relationship(rawValue: value)
    default:
      break
    }
  }
  
  func optionsForKey(key: String) -> [String] {
    switch key {
    case kBirthDate:
      return []
    case kSex:
      return User.Sex.optionsList
    case kRegion:
      return User.Region.optionsList
    case kLocality:
      return User.Locality.optionsList
    case kOccupation:
      return User.Occupation.optionsList
    case kIncome:
      return User.Income.optionsList
    case kEducation:
      return User.Education.optionsList
    case kRelationship:
      return User.Relationship.optionsList
    default:
      return []
    }
  }
  
  func valueForKey(key: String) -> String? {
    guard let user = user else {
      return nil
    }
    
    if tmpUser == nil {
      tmpUser = user.copy() as? User
    }
    
    switch key {
    case kBirthDate:
      guard let birthDate = tmpUser?.birthDate else {
        return nil
      }
      return dateFormatter.stringFromDate(birthDate)
    case kSex:
      return tmpUser?.sex?.rawValue
    case kRegion:
      return tmpUser?.region
    case kLocality:
      return tmpUser?.locality?.rawValue
    case kOccupation:
      return tmpUser?.occupation?.rawValue
    case kIncome:
      return tmpUser?.income?.rawValue
    case kEducation:
      return tmpUser?.education?.rawValue
    case kRelationship:
      return tmpUser?.relationship?.rawValue
    default:
      return nil
    }
  }
  
  //MARK: - UserDefaults
  
  func saveToUserDefaults() {
    guard let user = user else {
      return
    }
    
    let userData = NSKeyedArchiver.archivedDataWithRootObject(user)
    NSUserDefaults.standardUserDefaults().setObject(userData, forKey: kUser)
  }
  
  func loadFromUserDefaults() {
    guard let userData = NSUserDefaults.standardUserDefaults().objectForKey(kUser) as? NSData,
      user = NSKeyedUnarchiver.unarchiveObjectWithData(userData) as? User else {
       return
    }
    self.user = user
  }
}