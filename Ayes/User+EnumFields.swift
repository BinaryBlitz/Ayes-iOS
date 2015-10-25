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
    case Male
    case Female
    
    static var optionsList: [String] {
      return [Male.rawValue, Female.rawValue]
    }
  }
  
  //MARK: - Occupation
  
  enum Occupation: String, QuestionnaireItem {
    case Businessman
    case TopManager
    case MiddleManager
    case Engineer
    case Worker
    case Gos
    case Student
    case Pensioner
    case Unemployed
    
    static var optionsList: [String] {
      return [Businessman.rawValue, TopManager.rawValue, MiddleManager.rawValue,
          Engineer.rawValue, Worker.rawValue, Gos.rawValue, Student.rawValue,
          Pensioner.rawValue, Unemployed.rawValue]
    }
  }
  
  //MARK: - Income
  
  enum Income: String, QuestionnaireItem {
    case None
    case less10
    case from10to30
    case from30to60
    case from60to80
    case from80to100
    case from100to130
    case from130to160
    case more160
    
    static var optionsList: [String] {
      return [None.rawValue, less10.rawValue, from10to30.rawValue, from30to60.rawValue,
          from60to80.rawValue, from80to100.rawValue, from100to130.rawValue,
          from130to160.rawValue, more160.rawValue]
    }
  }
  
  //MARK: - Education
  
  enum Education: String, QuestionnaireItem {
    case HalfMiddle
    case HalfHigh
    case Middle
    case High
    case SpecializedSecondary
    case AcademicDegree
    
    static var optionsList: [String] {
      return [HalfMiddle.rawValue, HalfHigh.rawValue, Middle.rawValue, High.rawValue,
          SpecializedSecondary.rawValue, AcademicDegree.rawValue]
    }
  }
  
  //MARK: - Relationship
  
  enum Relationship: String, QuestionnaireItem {
    case Maried
    case NotMaried
    case Divorced
    case CivilMarriage
    case Widower
    
    static var optionsList: [String] {
      return [Maried.rawValue, NotMaried.rawValue, Divorced.rawValue,
       CivilMarriage.rawValue, Widower.rawValue]
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