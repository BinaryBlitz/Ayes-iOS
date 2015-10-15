//
//  QuestionTests.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import XCTest
@testable import Ayes

class QuestionTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
    MagicalRecord.setupCoreDataStack()
  }
  
  func testYesAnswers() {
    let question = Question.MR_createEntity()
    question.yesAnswers = 10
    
    XCTAssertTrue(question.yes == 10)
    question.MR_deleteEntity()
  }
  
  func testNoAnswers() {
    let question = Question.MR_createEntity()
    question.noAnswers = 10
    
    XCTAssertTrue(question.no == 10)
    question.MR_deleteEntity()
  }
  
  func testTotalAnswers() {
    let question = Question.MR_createEntity()
    question.noAnswers = 10
    question.yesAnswers = 10
    question.totalAnswers = 30
    
    XCTAssertTrue(question.total == 30)
    question.MR_deleteEntity()
  }
  
  func testYesNoTotalAnswers() {
    let question = Question.MR_createEntity()
    question.noAnswers = 10
    question.yesAnswers = 10
    question.totalAnswers = 70
    
    XCTAssertTrue(question.totalYesNo == 20)
    question.MR_deleteEntity()
  }
  
  
  func testAbstainAnswers() {
    let question = Question.MR_createEntity()
    question.noAnswers = 10
    question.yesAnswers = 10
    question.totalAnswers = 30
    
    XCTAssertTrue(question.abstainCount == 10)
    question.MR_deleteEntity()
  }
  
  func testYesPercentage() {
    let question = Question.MR_createEntity()
    question.noAnswers = 10
    question.yesAnswers = 10
    question.totalAnswers = 50
    
    XCTAssertTrue(question.yesPercent == 50)
    question.MR_deleteEntity()
  }
  
  func testNoPercentage() {
    let question = Question.MR_createEntity()
    question.noAnswers = 700
    question.yesAnswers = 300
    question.totalAnswers = 1200
    
    XCTAssertTrue(question.noPercent == 70)
    question.MR_deleteEntity()
  }
  
  func testAbstainPercentage() {
    let question = Question.MR_createEntity()
    question.noAnswers = 0
    question.yesAnswers = 300
    question.totalAnswers = 1000
    
    XCTAssertTrue(question.abstainPercent == 70)
    question.MR_deleteEntity()
  }
  
  func testZeroAnswers() {
    let question = Question.MR_createEntity()
    question.noAnswers = 0
    question.yesAnswers = 0
    question.totalAnswers = 0
    
    XCTAssertTrue(question.yes == 0)
    XCTAssertTrue(question.no == 0)
    XCTAssertTrue(question.total == 0)
    XCTAssertTrue(question.totalYesNo == 0)
    XCTAssertTrue(question.yesPercent == 0)
    XCTAssertTrue(question.noPercent == 0)
    XCTAssertTrue(question.abstainPercent == 0)
    XCTAssertTrue(question.abstainCount == 0)
    
    question.MR_deleteEntity()
  }
  
  func testZeroAnswers2() {
    let question = Question.MR_createEntity()
    question.noAnswers = 0
    question.yesAnswers = 0
    question.totalAnswers = 20
    
    XCTAssertTrue(question.yes == 0)
    XCTAssertTrue(question.no == 0)
    XCTAssertTrue(question.total == 20)
    XCTAssertTrue(question.totalYesNo == 0)
    XCTAssertTrue(question.yesPercent == 0)
    XCTAssertTrue(question.noPercent == 0)
    XCTAssertTrue(question.abstainPercent == 100)
    XCTAssertTrue(question.abstainCount == 20)
    
    question.MR_deleteEntity()
  }
}
