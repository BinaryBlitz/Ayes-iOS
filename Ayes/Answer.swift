//
//  Answer.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Answer: NSManagedObject {

  static func createWithQuestion(question: Question) -> Answer? {
    guard let question_id = question.id else {
      return nil
    }
    
    let answer = Answer.MR_createEntity()
    answer.question_id = question_id
    let value = question.state.toBool()
    if let value = value {
      answer.value = NSNumber(bool: value)
    } else {
      answer.value = nil
    }
    
    answer.sentToServer = false
    
    return answer
  }
}
