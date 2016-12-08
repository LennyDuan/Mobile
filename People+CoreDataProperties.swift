//
//  People+CoreDataProperties.swift
//  ToDo
//
//  Created by 段鸿易 on 12/8/16.
//  Copyright © 2016 Lenny. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension People {

    @NSManaged var address: String?
    @NSManaged var close: String?
    @NSManaged var email: String?
    @NSManaged var mobile: String?
    @NSManaged var name: String?
    @NSManaged var relation: String?
    @NSManaged var tasks: NSSet?

}
