//
//  Question.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 09/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation
import CoreData

class Question: NSManagedObject {
  
  var state: QuestionState {
    get {
      if let questionState = QuestionState(rawValue: Int(rawState ?? 0)) {
        return questionState
      }
      
      return  QuestionState.NoAnswer
    }
    set {
      rawState = newValue.rawValue
    }
  }
  
  var yes: Float {
    return Float(yesAnswers ?? 0)
  }
  
  var no: Float {
    return Float(noAnswers ?? 0)
  }
  
  var total: Float {
    return Float(totalAnswers ?? 0)
  }
  
  var totalYesNo: Float {
    return yes + no
  }
  
  var abstainCount: Float {
    return total - (yes + no)
  }
  
  var abstainPercent: Float {
    if total == 0 {
      return 0
    }
    
    return (abstainCount / total) * 100
  }
  
  var yesPercent: Float {
    if totalYesNo == 0 {
      return 0
    }
    
    return (yes / totalYesNo) * 100
  }
  
  var noPercent: Float {
    if totalYesNo == 0 {
      return 0
    }
    
    return (no / totalYesNo) * 100
  }
  
  var favorite: Bool {
    guard let favorite = isFavorite else {
      return false
    }
    
    return favorite.boolValue
  }
  
  func updateState(state: QuestionState) {
    self.state = state
    switch state {
    case .No:
      noAnswers = NSNumber(integer: (noAnswers ?? 0).integerValue + 1)
      totalAnswers = NSNumber(integer: (totalAnswers ?? 0).integerValue + 1)
    case .Yes:
      yesAnswers = NSNumber(integer: (yesAnswers ?? 0).integerValue + 1)
      totalAnswers = NSNumber(integer: (totalAnswers ?? 0).integerValue + 1)
    case .Skip:
      totalAnswers = NSNumber(integer: (totalAnswers ?? 0).integerValue + 1)
    case .NoAnswer:
      fatalError("You cannot change state to noAnswer")
    }
  }
  
}
