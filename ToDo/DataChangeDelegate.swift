//
//  DataChangeDelegate.swift
//  ToDo
//
//  Created by 段鸿易 on 12/7/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import Foundation

protocol DataChangedDelegate {
    
    func dataChanged(data: [String]) -> Void
    
}