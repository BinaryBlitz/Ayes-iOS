//
//  ComplexBirthDate.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

struct ComplexBirthDate {
  var startYear: Int?
  var endYear: Int?
  
  private let minYear = 1940
  private let maxYear = 2030
  
  init(years: [Int]) {
    if years.count > 2 || years.count == 0 {
      startYear = minYear
      endYear = maxYear
    }
    
    if years[0] == 0 {
      startYear = minYear
    } else {
      startYear = years[0]
    }
    
    if years[1] == 0 {
      endYear = maxYear
    } else {
      endYear = years[1]
    }
  }
  
  func getYearsArray() -> [Int] {
    return [startYear ?? 0, endYear ?? 0]
  }
}