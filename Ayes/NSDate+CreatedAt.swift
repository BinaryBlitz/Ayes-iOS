//
//  NSDate+CreatedAt.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 21/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

extension NSDate {
  convenience init?(dateString: String) {
    let formatter = NSDateFormatter()
    formatter.timeZone = NSTimeZone(name: "UTC")
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    guard let date = formatter.dateFromString(dateString) else {
      return nil
    }
    
    self.init(timeIntervalSince1970: date.timeIntervalSince1970)
  }
}