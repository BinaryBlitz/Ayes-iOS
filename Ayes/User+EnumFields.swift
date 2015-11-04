//
//  User+EnumFields.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 25/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

extension User {
  
  //MARK: - Sex
  
  enum Sex: String, QuestionnaireItem {
    case Male = "male"
    case Female = "female"
    
    static var optionsList: [String] {
      return [Male.rawValue, Female.rawValue]
    }
  }
  
  //MARK: - Occupation
  
  enum Occupation: String, QuestionnaireItem {
    case Businessman = "businessman"
    case TopManager = "top_manager"
    case MiddleManager = "middle_manager"
    case Engineer = "engineer"
    case Worker = "worker"
    case Gos = "civil_servant"
    case Student = "student"
    case Pensioner = "pensioner"
    case Unemployed = "unemployed"
    
    static var optionsList: [String] {
      return [Businessman.rawValue, TopManager.rawValue, MiddleManager.rawValue,
          Engineer.rawValue, Worker.rawValue, Gos.rawValue, Student.rawValue,
          Pensioner.rawValue, Unemployed.rawValue]
    }
  }
  
  //MARK: - Income
  
  enum Income: String, QuestionnaireItem {
    case None = "none"
    case less10 = "over0"
    case from10to30 = "over10000"
    case from30to60 = "over30000"
    case from60to80 = "over60000"
    case from80to100 = "over80000"
    case from100to130 = "over100000"
    case from130to160 = "over130000"
    case more160 = "over160000"
    
    static var optionsList: [String] {
      return [None.rawValue, less10.rawValue, from10to30.rawValue, from30to60.rawValue,
          from60to80.rawValue, from80to100.rawValue, from100to130.rawValue,
          from130to160.rawValue, more160.rawValue]
    }
  }
  
  //MARK: - Education
  
  enum Education: String, QuestionnaireItem {
    case LowerSecondary = "lower_secondary"
    case IncompleteHigher = "upper_secondary"
    case UpperSecondary = "incomplete_higher"
    case Higher = "higher"
    case College = "vocational"
    case Academic = "academic"
    
    static var optionsList: [String] {
      return [LowerSecondary.rawValue, IncompleteHigher.rawValue,
        UpperSecondary.rawValue, Higher.rawValue, College.rawValue, Academic.rawValue]
    }
  }
  
  //MARK: - Relationship
  
  enum Relationship: String, QuestionnaireItem {
    case Maried = "married"
    case NotMaried = "single"
    case Divorced = "divorced"
    case CivilUnion = "civil_union"
    case Widow = "widow"
    
    static var optionsList: [String] {
      return [Maried.rawValue, NotMaried.rawValue, Divorced.rawValue,
       CivilUnion.rawValue, Widow.rawValue]
    }
  }
  
  //MARK: - City
  
  enum City: String, QuestionnaireItem {
    case Moscow
    case SPB
    
    static var optionsList: [String] {
      return [Moscow.rawValue, SPB.rawValue]
    }
  }
}