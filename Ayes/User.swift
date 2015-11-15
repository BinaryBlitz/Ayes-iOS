//
//  User.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
import SwiftyJSON

class User: NSObject, NSCoding, NSCopying {
  
  var birthDate: NSDate?
  var sex: Sex?
  var region: String?
  var locality: Locality?
  var occupation: Occupation?
  var income: Income?
  var education: Education?
  var relationship: Relationship?
  
  var lastUpdate: NSDate?
  
  required override init() {
    super.init()
  }
  
  func copyWithZone(zone: NSZone) -> AnyObject {
    let userCopy = self.dynamicType.init()
    userCopy.birthDate = birthDate
    userCopy.sex = sex
    userCopy.region = region
    userCopy.locality = locality
    userCopy.occupation = occupation
    userCopy.income = income
    userCopy.education = education
    userCopy.relationship = relationship
    
    return userCopy
  }
  
  func isAllFieldsFilled() -> Bool {
    
    if Settings.sharedInstance.country == Settings.Country.World {
      
      return birthDate != nil && sex != nil && region != nil &&
        occupation != nil && income != nil && education != nil &&
        relationship != nil
    }
    
    return birthDate != nil && sex != nil && region != nil &&
      occupation != nil &&
      income != nil && education != nil && relationship != nil &&
      (locality != nil || region == "MOW" || region == "SPE")
  }
  
  
  //MARK: - NSCoding
  
  @objc required init(coder aDecoder: NSCoder) {
    birthDate = aDecoder.decodeObjectForKey(kBirthDate) as? NSDate
    if let rawSex = aDecoder.decodeObjectForKey(kSex) as? String {
      sex = Sex(rawValue: rawSex)
    }
    if let value = aDecoder.decodeObjectForKey(kRegion) as? String {
      region = value
    }
    if let rawLocality = aDecoder.decodeObjectForKey(kLocality) as? String {
      locality = Locality(rawValue: rawLocality)
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
    
    if let lastUpdate = aDecoder.decodeObjectForKey("lastUpdate") as? NSDate {
      self.lastUpdate = lastUpdate
    }
  }
  
  @objc func encodeWithCoder(aCoder: NSCoder) {
    aCoder.encodeObject(birthDate, forKey: kBirthDate)
    aCoder.encodeObject(sex?.rawValue, forKey: kSex)
    aCoder.encodeObject(region, forKey: kRegion)
    aCoder.encodeObject(locality?.rawValue, forKey: kLocality)
    aCoder.encodeObject(occupation?.rawValue, forKey: kOccupation)
    aCoder.encodeObject(income?.rawValue, forKey: kIncome)
    aCoder.encodeObject(education?.rawValue, forKey: kEducation)
    aCoder.encodeObject(relationship?.rawValue, forKey: kRelationship)
    aCoder.encodeObject(lastUpdate, forKey: "lastUpdate")
  }
}