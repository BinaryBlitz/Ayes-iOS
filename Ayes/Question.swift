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

  @NSManaged var id: NSNumber?
  @NSManaged var state: NSNumber?
  @NSManaged var dateCreated: NSDate?
  @NSManaged var content: String?
  @NSManaged var yesStatistic: NSNumber?
  @NSManaged var noStatistic: NSNumber?
  @NSManaged var skipStatistic: NSNumber?
  @NSManaged var isFavorite: NSNumber?

  

}
