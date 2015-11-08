//
//  StatDataDisplay.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 08/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

enum StatType {
  case Normal
  case Similar
}

protocol StatDataDisplay: class {
  func didChangeStatType(type: StatType)
}