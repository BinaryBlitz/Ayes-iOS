//
//  PNPieChartDataItem+Float.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

extension PNPieChartDataItem {
  convenience init(value: Float, color: UIColor) {
    self.init(value: CGFloat(value), color: color)
  }
}