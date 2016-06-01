//
//  Tag+CoreDataProperties.swift
//  ViewDemo
//
//  Created by 段鸿易 on 3/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tag {

    @NSManaged var name: String?
    @NSManaged var wordPairs: NSSet?

}
