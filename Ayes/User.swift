//
//  User.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
import SwiftyJSON

class User: NSObject, NSCoding {
  
  var birthDate: NSDate?
  var sex: Sex?
  var city: City?
  var occupation: Occupation?
  var income: Income?
  var education: Education?
  var relationship: Relationship?
  
  override init() {
    super.init()
  }
  
  func isAllFieldsFilled() -> Bool {
    return birthDate != nil && sex != nil && city != nil && occupation != nil &&
      income != nil && education != nil && relationship != nil
  }
  
  //MARK: - NSCoding
  
  @objc required init(coder aDecoder: NSCoder) {
    birthDate = aDecoder.decodeObjectForKey(kBirthDate) as? NSDate
    if let rawSex = aDecoder.decodeObjectForKey(kSex) as? String {
      sex = Sex(rawValue: rawSex)
    }
    if let rawCity = aDecoder.decodeObjectForKey(kCity) as? String {
      city = City(rawValue: rawCity)
    }
    if let rawOccupation = aDecoder.decodeObjectForKey(kOccupation) as? String {
      occupation = Occupation(rawValue: rawOccupation)
    }
    if let rawIncome = aDecoder.decodeObjectForKey(kIncome) as? String {
      income = Income(rawValue: rawIncome)
    }
    if let rawEducation = aDecoder.decodeObjectForKey(kEducation) as? String {
      education = Education(rawValue: rawEducation)
    }
    if let rawRelationship = aDecoder.decodeObjectForKey(kRelationship) as? String {
      relationship = Relationship(rawValue: rawRelationship)
    }
  }
  
  @objc func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(birthDate, forKey: kBirthDate)
    aCoder.encodeObject(sex?.rawValue, forKey: kSex)
    aCoder.encodeObject(city?.rawValue, forKey: kCity)
    aCoder.encodeObject(occupation?.rawValue, forKey: kOccupation)
    aCoder.encodeObject(income?.rawValue, forKey: kIncome)
    aCoder.encodeObject(education?.rawValue, forKey: kEducation)
    aCoder.encodeObject(relationship?.rawValue, forKey: kRelationship)
  }
}