//
//  PageContentViewController.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

  @IBOutlet weak var textContainerView: UIView!
  @IBOutlet weak var contentImageView: UIImageView!
  @IBOutlet weak var contentLabel: UILabel!
  private var _index = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textContainerView.backgroundColor = UIColor.darkVioletPrimaryColor()
  }
}

extension PageContentViewController: OnboardingPageContent {
  
  var index: Int {
    get {
      return _index
    }
    set {
      _index = newValue
    }
  }
}
