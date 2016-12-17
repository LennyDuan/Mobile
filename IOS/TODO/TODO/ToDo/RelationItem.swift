//
//  relationItem.swift
//  ToDo
//
//  Created by 段鸿易 on 12/7/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import Foundation

// This represents an item that can be selected. It holds the actual data,
// which is a simple string in this example, and the selected status
// for the item.
struct RelationItem {
    
    var data: String?
    
    var selected = false
    
    init(data: String) {
        self.data = data
    }
    
    init(data: String, selected: Bool) {
        self.data = data
        self.selected = selected
    }
    
}

