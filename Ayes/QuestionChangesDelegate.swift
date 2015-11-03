//
//  QuestionChangesDelegate.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 17/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@objc protocol QuestionChangesDelegate: class {
  optional func didAnswerTheQuestion(question: Question)
  optional func didFavoriteTheQuestion(question: Question)
}
