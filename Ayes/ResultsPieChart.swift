//
//  ResultsPieChart.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

class ResultsPieChart: PNPieChart {
  
  var circleThickness: CGFloat = 5
  
  override func recompute() {
    outerCircleRadius = bounds.width / 2
    innerCircleRadius = bounds.width / 2 - circleThickness
  }
}