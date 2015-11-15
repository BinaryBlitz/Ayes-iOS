//
//  QuestionnaireItem.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 25/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

protocol QuestionnaireItem {
  static var optionsList: [String] { get }
  var rawValue: String { get }
}
