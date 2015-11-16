//
//  ComplexUserManager.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

let kAge = "age"

class ComplexUserManager {
  
  static let sharedManager = ComplexUserManager()
  
  var user: ComplexUser?
  var avalableKeys: [String] {
    return [kAge, kSex, kRegion, kLocality,
      kOccupation, kIncome, kEducation, kRelationship]
  }
  
  let dateFormatter: NSDateFormatter
  
  init() {
    user = ComplexUser()
    dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "dd.MM.yyyy"
  }

  func atLeastOneFilled() -> Bool {
    for key in avalableKeys {
      if valuesForKey(key)?.count != 0 {
        return true
      }
    }

    return false
  }
  
  func updateKey(key: String, withValues values: [String]) {
    guard let user = user else {
      return
    }
    
    switch key {
    case kAge:
      user.age = values.flatMap { (string) -> Int? in
        return Int(string)
      }
    case kSex:
      user.sex = values.flatMap { (value) -> User.Sex? in
        return User.Sex(rawValue: value)
      }
    case kRegion:
      user.region = values
    case kLocality:
      user.locality = values.flatMap { (value) -> User.Locality? in
        return User.Locality(rawValue: value)
      }
    case kOccupation:
      user.occupation = values.flatMap { (value) -> User.Occupation? in
        return User.Occupation(rawValue: value)
      }
    case kIncome:
      user.income = values.flatMap { (value) -> User.Income? in
        return User.Income(rawValue: value)
      }
    case kEducation:
      user.education = values.flatMap { (value) -> User.Education? in
        return User.Education(rawValue: value)
      }
    case kRelationship:
      user.relationship = values.flatMap { (value) -> User.Relationship? in
        return User.Relationship(rawValue: value)
      }
    default:
      break
    }
  }
  
  func optionsForKey(key: String) -> [String] {
    switch key {
    case kAge:
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
  
  func valuesForKey(key: String) -> [String]? {
    guard let user = user else {
      return nil
    }
    
    switch key {
    case kAge:
      return user.age.map { (age) -> String in
        return String(age)
      }
    case kSex:
      return user.sex.map { (sex) -> String in
        return sex.rawValue
      }
    case kRegion:
      return user.region
    case kLocality:
      return user.locality.map { (locality) -> String in
        return locality.rawValue
      }
    case kOccupation:
      return user.occupation.map { (occupation) -> String in
        return occupation.rawValue
      }
    case kIncome:
      return user.income.map { (income) -> String in
        return income.rawValue
      }
    case kEducation:
      return user.education.map { (education) -> String in
        return education.rawValue
      }
    case kRelationship:
      return user.relationship.map { (relationship) -> String in
        return relationship.rawValue
      }
    default:
      return nil
    }
  }
}