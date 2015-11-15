//
//  String+Localize.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

extension String {
  
  func localize() -> String? {
    return LocalizeHelper.localizeStringForKey(self)
  }
}
