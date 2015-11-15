//
//  QuestionResultsViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 15/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class QuestionResultsViewController: UIViewController {

  @IBOutlet weak var skipStatLabel: UILabel!
  @IBOutlet weak var noColorMarkView: UIView!
  @IBOutlet weak var yesColorMarkView: UIView!
  @IBOutlet weak var noLegendLabel: UILabel!
  @IBOutlet weak var yesLegendLabel: UILabel!
  @IBOutlet weak var percentageLabel: UICountingLabel!
  @IBOutlet weak var chartContainerView: UIView!
  var pieChart: ResultsPieChart!
  
  var question: Question!
  var statType: StatType = .Normal
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    yesLegendLabel.text = "Yes".localize()
    yesLegendLabel.textColor = UIColor.whiteColor()
    noLegendLabel.text = "No".localize()
    noLegendLabel.textColor = UIColor.whiteColor()
    yesColorMarkView.backgroundColor = UIColor.greenAccentColor()
    noColorMarkView.backgroundColor = UIColor.redAccentColor()
    
    skipStatLabel.textColor = UIColor.whiteColor()
    chartContainerView.backgroundColor = nil
    
    pieChart = ResultsPieChart(frame: CGRect(), items: [])
    pieChart.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    addContent(pieChart, toView: chartContainerView)
    pieChart.descriptionTextColor = UIColor.whiteColor()
    pieChart.descriptionTextFont = UIFont(name: "Roboto-Light", size: 14)
    pieChart.duration = 1.5
    pieChart.circleThickness = 10
    pieChart.shouldHighlightSectorOnTouch = false
    pieChart.labelPercentageCutoff = 100
    pieChart.strokeChart()
    let stat = question.stat as! Stat
    update(stat)
  }
  
  func update(stat: Stat) {
    if stat.abstainPercent == 0 {
      skipStatLabel.hidden = true
    } else {
      skipStatLabel.hidden = false
      skipStatLabel.text = "Abstain".localize()! + " \(stat.abstainPercent)%"
    }
    
    setUpPieChartWithYesAnswers(stat.yes, noAnswers: stat.no)
    setUpPercentageLabel(stat.yesPercent)
  }
  
  func setUpPercentageLabel(yesPercent: Int) {
    percentageLabel.textColor = UIColor.whiteColor()
    percentageLabel.format = "%d%%"
    percentageLabel.countFrom(0, to: Float(yesPercent), withDuration: pieChart.duration)
  }
  
  func setUpPieChartWithYesAnswers(yesAnswers: Int, noAnswers: Int) {
    let items = [PNPieChartDataItem(value: Float(yesAnswers), color: UIColor.greenAccentColor()),
      PNPieChartDataItem(value: Float(noAnswers), color: UIColor.redAccentColor())]
    pieChart.updateChartData(items)
    pieChart.strokeChart()
  }
  
  func addContent(content: UIView, toView contentView: UIView) {
    content.translatesAutoresizingMaskIntoConstraints = false
    contentView.addSubview(content)
    let topConstraint = NSLayoutConstraint(item: content, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0)
    let bottomContraint = NSLayoutConstraint(item: content, attribute: .Bottom, relatedBy: .Equal, toItem: contentView, attribute: .Bottom, multiplier: 1, constant: 0)
    let trallingConstaint = NSLayoutConstraint(item: content, attribute: .Trailing, relatedBy: .Equal, toItem: contentView, attribute: .Trailing, multiplier: 1, constant: 0)
    let leadingConstraint = NSLayoutConstraint(item: content, attribute: .Leading, relatedBy: .Equal, toItem: contentView, attribute: .Leading, multiplier: 1, constant: 0)
    contentView.addConstraints([topConstraint, bottomContraint, leadingConstraint, trallingConstaint])
  }
}

extension QuestionResultsViewController: StatDataDisplay {
  func didChangeStatType(type: StatType) {
    switch type {
    case .Similar:
      if let similarStat = question.similarStat as? Stat {
        update(similarStat)
      }
    case .Normal:
      let stat = question.stat as! Stat
      update(stat)
    case let .Other(stat):
      update(stat)
    }
  }
}
