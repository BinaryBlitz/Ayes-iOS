//
//  Favorite.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation
import CoreData


class Favorite: NSManagedObject {

  static func createWithQuestion(question: Question) -> Favorite? {
    guard let question_id = question.id else {
      return nil
    }
    
    let favorite = Favorite.MR_createEntity()
    favorite.question_id = question_id
    
    return favorite
  }

}
