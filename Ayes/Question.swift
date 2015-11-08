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
      epigraph = json["epigraph"].string
      else {
        return nil
    }
    
    let questions = Question.findAllSortedBy("id", ascending: true) as! [Question]
    for q in questions {
      if q.id?.integerValue == id {
        q.epigraph = epigraph
        q.content = content
        q.dateCreated = NSDate(dateString: createdAtString) ?? NSDate()
        if let stat = q.stat as? Stat {
          stat.updateWithJSON(json["answers"])
        }

        return q
      }
    }
    
    let question = Question.MR_createEntity()
    question.id = NSNumber(integer: id)
    question.content = content
    question.epigraph = epigraph
    question.stat = Stat.createFromJSON(json["answers"])
    
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
  
  var favorite: Bool {
    guard let favorite = isFavorite else {
      return false
    }
    
    return favorite.boolValue
  }
  
  func updateState(state: QuestionState) {
    self.state = state
    guard let stat = stat as? Stat else {
      return
    }
    
    switch state {
    case .No:
      stat.negative = NSNumber(integer: stat.no + 1)
    case .Yes:
      stat.positive = NSNumber(integer: stat.yes + 1)
    case .Skip:
      stat.neutral = NSNumber(integer: stat.skip + 1)
    case .NoAnswer:
      fatalError("You cannot change state to noAnswer")
    }
  }
}
