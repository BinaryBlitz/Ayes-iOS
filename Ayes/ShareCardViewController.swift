//
//  ShareCardViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 24/11/2015.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class ShareCardViewController: UIViewController {

  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var yesPercentLabel: UILabel!
  @IBOutlet weak var skipStatLabel: UILabel!
  
  @IBOutlet weak var noColorMarkView: UIView!
  @IBOutlet weak var yesColorMarkView: UIView!
  @IBOutlet weak var noLegendLabel: UILabel!
  @IBOutlet weak var yesLegendLabel: UILabel!
  @IBOutlet weak var chartContainerView: UIView!
  var pieChart: ResultsPieChart!
  private var question: Question!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    configureLabels()
    yesColorMarkView.backgroundColor = .greenAccentColor()
    noColorMarkView.backgroundColor = .redAccentColor()
    configurePieChart()
//    configureWithQuestion(question, andStatType: .Normal)
  }
  
  //MARK: - Private configuration methods
  
  private func configureLabels() {
    yesLegendLabel.text = "Yes".localize()
    yesLegendLabel.textColor = .whiteColor()
    noLegendLabel.text = "No".localize()
    noLegendLabel.textColor = .whiteColor()
    skipStatLabel.textColor = .whiteColor()
  }
  
  private func configurePieChart() {
    chartContainerView.backgroundColor = nil
    pieChart = ResultsPieChart(frame: CGRect(), items: [])
    pieChart.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
    UIView.addContent(pieChart, toView: chartContainerView)
    pieChart.descriptionTextColor = UIColor.whiteColor()
    pieChart.descriptionTextFont = UIFont(name: "Roboto-Light", size: 14)
    pieChart.duration = 1.5
    pieChart.circleThickness = 10
    pieChart.shouldHighlightSectorOnTouch = false
    pieChart.labelPercentageCutoff = 100
    pieChart.strokeChart()
  }
  
  //MARK: - Configuration
  
  func configureWithQuestion(question: Question, andStatType  type: StatType) {
    self.question = question
    
    if let content = question.content {
      if let epigraph = question.epigraph where epigraph != "" {
        let format = "%@\n\n%@"
        let formattedString = String(format: format, epigraph, content)
        let attributedString = NSMutableAttributedString(string: formattedString)
        let epigraphRange = (formattedString as NSString).rangeOfString(epigraph)
        let font = UIFont(name: "Roboto-LightItalic", size: 25)!
        attributedString.addAttribute(NSFontAttributeName, value: font, range: epigraphRange)

        contentLabel.attributedText = attributedString
      } else {
        contentLabel.text = content
      }
    }
    updateWithStatType(type)
  }
  
  private func updateWithStatType(type: StatType) {
    switch type {
    case .Similar:
      if let similarStat = question.similarStat {
        update(similarStat)
      }
    case .Normal:
      let stat = question.stat!
      update(stat)
    case let .Other(stat):
      update(stat)
    }
  }

  private func update(stat: Stat) {
    if stat.abstainPercent == 0 {
      skipStatLabel.hidden = true
    } else {
      skipStatLabel.hidden = false
      skipStatLabel.text = "\("Abstain".localize() ?? "") \(stat.abstainPercent)%"
    }

    setUpPieChartWithYesAnswers(stat.yes, noAnswers: stat.no)
    setUpPercentageLabel(stat.yesPercent)
  }

  private func setUpPercentageLabel(yesPercent: Int) {
    yesPercentLabel.textColor = UIColor.whiteColor()
    yesPercentLabel.text = "\(yesPercent)%"
  }

  private func setUpPieChartWithYesAnswers(yesAnswers: Int, noAnswers: Int) {
    let items = [PNPieChartDataItem(value: Float(yesAnswers), color: UIColor.greenAccentColor()),
                 PNPieChartDataItem(value: Float(noAnswers), color: UIColor.redAccentColor())]
    pieChart.updateChartData(items)
    pieChart.strokeChart()
  }
}
