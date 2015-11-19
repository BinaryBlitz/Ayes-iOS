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
      publishedAtString = json["published_at"].string
      else {
        return nil
    }
    
    if let q = Question.MR_findFirstByAttribute("id", withValue: id) {
        q.epigraph = epigraph
        q.content = content
        q.dateCreated = NSDate(dateString: createdAtString) ?? NSDate()
        q.publishedAt = NSDate(dateString: publishedAtString) ?? NSDate()
        if let stat = q.stat {
          stat.updateWithJSON(json["answers"])
        }

        return q
    }
    
    let question = Question.MR_createEntity()
    question.id = NSNumber(integer: id)
    question.content = content
    question.epigraph = epigraph
    question.stat = Stat.createFromJSON(json["answers"])

    if let _ = Favorite.findFirstByAttribute("question_id", withValue: NSNumber(integer: id)) {
      question.isFavorite = true
    } else {
      question.isFavorite = false
    }
    
    if let answer = Answer.findFirstByAttribute("question_id", withValue: NSNumber(integer: id)) {
      if let value = answer.value {
        if value.boolValue {
          question.updateState(.Yes)
        } else {
          question.updateState(.No)
        }
      } else {
        question.updateState(.Skip)
      }
    }
    
    if let createdAt = NSDate(dateString: createdAtString) {
      question.dateCreated = createdAt
    }
    
    if let publishedAt = NSDate(dateString: publishedAtString) {
      question.publishedAt = publishedAt
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
    guard let stat = stat else {
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
