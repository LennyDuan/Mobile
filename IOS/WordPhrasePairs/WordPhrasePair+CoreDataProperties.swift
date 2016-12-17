//
//  WordPhrasePair+CoreDataProperties.swift
//  ViewDemo
//
//  Created by 段鸿易 on 4/12/16.
//  Copyright © 2016 Lenny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension WordPhrasePair {

    @NSManaged var english: String?
    @NSManaged var note: String?
    @NSManaged var type: String?
    @NSManaged var welsh: String?
    @NSManaged var revision: Revision?
    @NSManaged var tags: NSSet?

}
