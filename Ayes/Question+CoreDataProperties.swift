//
//  Question+CoreDataProperties.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 11/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Question {

    @NSManaged var content: String?
    @NSManaged var dateCreated: NSDate?
    @NSManaged var id: NSNumber?
    @NSManaged var isFavorite: NSNumber?
    @NSManaged var noAnswers: NSNumber?
    @NSManaged var rawState: NSNumber?
    @NSManaged var totalAnswers: NSNumber?
    @NSManaged var yesAnswers: NSNumber?

}
