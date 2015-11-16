//
//  Favorite+CoreDataProperties.swift
//  Ayes
//
//  Created by Dan Shevlyuk on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Favorite {

    @NSManaged var question_id: NSNumber?
    @NSManaged var sentToServer: NSNumber?

}
