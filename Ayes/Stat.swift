//
//  Stat.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 08/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON


class Stat: NSManagedObject {
  
  static func createFromJSON(json: JSON) -> Stat? {
    guard let positive = json["positive"].int,
      negative = json["negative"].int,
      neutral = json["neutral"].int
      else {
        return nil
    }
    
    let stat = Stat.MR_createEntity()
    stat.negative = negative
    stat.positive = positive
    stat.neutral = neutral
    
    return stat
  }
  
  func updateWithJSON(json: JSON) {
    guard let positive = json["positive"].int,
      negative = json["negative"].int,
      neutral = json["neutral"].int
      else {
        return
    }
    
    self.negative = negative
    self.positive = positive
    self.neutral = neutral
  }
  
  var yes: Int {
    return Int(positive ?? 0)
  }
  
  var no: Int {
    return Int(negative ?? 0)
  }
  
  var skip: Int {
    return Int(neutral ?? 0)
  }
  
  var total: Int {
    return yes + no + skip
  }
  
  var totalYesNo: Int {
    return yes + no
  }
  
  var abstainPercent: Int {
    if total == 0 {
      return 0
    }
    
    return Int((Float(skip) / Float(total)) * 100)
  }
  
  var yesPercent: Int {
    if totalYesNo == 0 {
      return 0
    }
    
    return Int((Float(yes) / Float(totalYesNo)) * 100)
  }
  
  var noPercent: Int {
    if totalYesNo == 0 {
      return 0
    }
    
    return Int((Float(no) / Float(totalYesNo)) * 100)
  }
}
