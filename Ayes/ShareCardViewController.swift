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
  
  // chart stuff
  @IBOutlet weak var noColorMarkView: UIView!
  @IBOutlet weak var yesColorMarkView: UIView!
  @IBOutlet weak var noLegendLabel: UILabel!
  @IBOutlet weak var yesLegendLabel: UILabel!
  @IBOutlet weak var chartContainerView: UIView!
  var pieChart: ResultsPieChart!
  var question: Question!

  override func viewDidLoad() {
    super.viewDidLoad()

    print("share card did load")
    
//    view.backgroundColor = UIColor.violetPrimaryColor()

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
    configureWithQuestion(question!)
  }
  
  func configureWithQuestion(question: Question) {
    if let content = question.content {
      if let epigraph = question.epigraph where epigraph != "" {
        let format = "%@\n\n%@"
        let formattedString = String(format: format, epigraph, content)
        let attributedString = NSMutableAttributedString(string: formattedString)
        attributedString.addAttribute(NSFontAttributeName, value: UIFont(name: "Roboto-LightItalic", size: 25)!, range: (formattedString as NSString).rangeOfString(epigraph))

        contentLabel.attributedText = attributedString
      } else {
        contentLabel.text = content
      }
    }
    let stat = question.stat!
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
    yesPercentLabel.textColor = UIColor.whiteColor()
    yesPercentLabel.text = "\(yesPercent)%"
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
