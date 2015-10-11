//
//  QuestionState.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 11/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

enum QuestionState: Int {
  
  case NoAnswer
  case Yes
  case No
  case Skip
  
  func getAccentColor() -> UIColor {
    switch self {
    case .NoAnswer, .Skip:
      return UIColor.blueAccentColor()
    case .No:
      return UIColor.redAccentColor()
    case .Yes:
      return UIColor.greenAccentColor()
    }
  }
  
}