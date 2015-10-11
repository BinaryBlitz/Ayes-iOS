//
//  QuestionTableViewCell.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 06/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {

  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var questionStatusLabel: UILabel!
  @IBOutlet weak var idLabel: UILabel!
  @IBOutlet weak var dateLabel: UILabel!
  @IBOutlet weak var questionStateIndicator: UIView!
  @IBOutlet weak var separatorLineHeightConstraint: NSLayoutConstraint!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    separatorLineHeightConstraint.constant = 1 / UIScreen.mainScreen().scale
    let indicatorWidth = questionStateIndicator.frame.width
    questionStateIndicator.layer.cornerRadius = indicatorWidth / 2
    questionStateIndicator.backgroundColor = UIColor.redAccentColor()
    contentTextView.textContainer.maximumNumberOfLines = 4
    contentTextView.textContainer.lineBreakMode = NSLineBreakMode.ByTruncatingTail
    
    contentView.backgroundColor = UIColor.lightGreenBackgroundColor()
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

  }
}
