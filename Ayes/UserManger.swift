//
//  UserManger.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 25/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

internal let kBirthDate = "birthdate"
internal let kSex = "gender"
internal let kRegion = "region"
internal let kCity = "city"
internal let kOccupation = "occupation"
internal let kIncome = "income"
internal let kEducation = "education"
internal let kRelationship = "relationship"

/// Helps with shared user instance
class UserManager {
  
  static let sharedManager = UserManager()
  private let kUser = "ayesUser"
  
  var user: User? {
    didSet {
      saveToUserDefaults()
    }
  }
  
  var avalableKeys: [String] {
    return [kBirthDate, kSex, kRegion,
      kOccupation, kIncome,
      kEducation, kRelationship]
  }
  
  let dateFormatter: NSDateFormatter
  
  init() {
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
  }
  
  func updateKey(key: String, withValue value: String) {
    switch key {
    case kBirthDate:
      user?.birthDate = dateFormatter.dateFromString(value)
    case kSex:
      user?.sex = User.Sex(rawValue: value)
    case kRegion:
      user?.region = User.Region(rawValue: value)
    case kOccupation:
      user?.occupation = User.Occupation(rawValue: value)
    case kIncome:
      user?.income = User.Income(rawValue: value)
    case kEducation:
      user?.education = User.Education(rawValue: value)
    case kRelationship:
      user?.relationship = User.Relationship(rawValue: value)
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
    switch key {
    case kBirthDate:
      guard let birthDate = user?.birthDate else {
        return nil
      }
      return dateFormatter.stringFromDate(birthDate)
    case kSex:
      return user?.sex?.rawValue
    case kRegion:
      return user?.region?.rawValue
    case kOccupation:
      return user?.occupation?.rawValue
    case kIncome:
      return user?.income?.rawValue
    case kEducation:
      return user?.education?.rawValue
    case kRelationship:
      return user?.relationship?.rawValue
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