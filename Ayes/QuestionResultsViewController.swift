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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    yesLegendLabel.text = LocalizeHelper.localizeStringForKey("Yes")
    yesLegendLabel.textColor = UIColor.whiteColor()
    noLegendLabel.text = LocalizeHelper.localizeStringForKey("No")
    noLegendLabel.textColor = UIColor.whiteColor()
    yesColorMarkView.backgroundColor = UIColor.greenAccentColor()
    noColorMarkView.backgroundColor = UIColor.redAccentColor()
    
    skipStatLabel.textColor = UIColor.whiteColor()
    skipStatLabel.text = LocalizeHelper.localizeStringForKey("Abstain")! + " \(Int(question.abstainPercent))%"
    
    chartContainerView.backgroundColor = nil
    setUpPieChartWithYesAnswers(question.yes, noAnswers: question.no)
    setUpPercentageLabel()
  }
  
  func setUpPercentageLabel() {
    percentageLabel.textColor = UIColor.whiteColor()
    percentageLabel.format = "%d%%"
    percentageLabel.countFrom(0, to: question.yesPercent, withDuration: pieChart.duration)
  }
  
  func setUpPieChartWithYesAnswers(yesAnswers: Float, noAnswers: Float) {
    let items = [PNPieChartDataItem(value: noAnswers, color: UIColor.redAccentColor()),
        PNPieChartDataItem(value: yesAnswers, color: UIColor.greenAccentColor())]
  
    pieChart = ResultsPieChart(frame: CGRect(), items: items)
    addContent(pieChart, toView: chartContainerView)
    pieChart.descriptionTextColor = UIColor.whiteColor()
    pieChart.descriptionTextFont = UIFont.systemFontOfSize(14)
    pieChart.duration = 1.5
    pieChart.circleThickness = 10
    pieChart.shouldHighlightSectorOnTouch = false
    pieChart.labelPercentageCutoff = 100
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
