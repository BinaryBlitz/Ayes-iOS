//
//  ComplexUser.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 12/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

class ComplexUser {
  
  var birthDate: ComplexBirthDate?
  var sex: [User.Sex] = []
  var region = [String]()
  var locality: [User.Locality] = []
  var occupation: [User.Occupation] = []
  var income: [User.Income] = []
  var education: [User.Education] = []
  var relationship: [User.Relationship] = []
  
}