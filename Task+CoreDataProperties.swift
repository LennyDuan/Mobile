//
//  Task+CoreDataProperties.swift
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

extension Task {

    @NSManaged var detail: String?
    @NSManaged var end: String?
    @NSManaged var hard: String?
    @NSManaged var priority: String?
    @NSManaged var start: String?
    @NSManaged var status: String?
    @NSManaged var tag: String?
    @NSManaged var title: String?
    @NSManaged var people: People?

}
