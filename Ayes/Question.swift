//
//  Question.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 09/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

class Question: NSManagedObject {
  
  static func createFromJSON(json: JSON) -> Question? {
    guard let id = json["id"].int,
      content = json["content"].string,
      createdAtString = json["created_at"].string,
      epigraph = json["epigraph"].string,
      positive = json["answers"]["positive"].int,
      negative = json["answers"]["negative"].int,
      neutral = json["answers"]["neutral"].int
      else {
        return nil
    }
    
    let questions = Question.findAllSortedBy("id", ascending: true) as! [Question]
    for q in questions {
      if q.id?.integerValue == id {
        q.epigraph = epigraph
        q.content = content
        q.dateCreated = NSDate(dateString: createdAtString) ?? NSDate()
        q.yesAnswers = positive
        q.noAnswers = negative
        q.totalAnswers = q.yes + q.no + Float(neutral)

        return q
      }
    }
    
    
    let question = Question.MR_createEntity()
    question.id = NSNumber(integer: id)
    question.content = content
    question.epigraph = epigraph
    question.yesAnswers = Int(positive)
    question.noAnswers = Int(negative)
    question.totalAnswers = Int(question.yes + question.no) + (Int(neutral) ?? 0)
    
    if let createdAt = NSDate(dateString: createdAtString) {
      question.dateCreated = createdAt
    }
    
    
    return question
  }
  
  var answer: Answer? {
    return Answer.createWithQuestion(self)
  }
  
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
