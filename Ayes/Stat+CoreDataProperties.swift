//
//  Stat+CoreDataProperties.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 08/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Stat {

    @NSManaged var negative: NSNumber?
    @NSManaged var positive: NSNumber?
    @NSManaged var neutral: NSNumber?

}
