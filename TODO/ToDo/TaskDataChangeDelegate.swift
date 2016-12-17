//
//  TaskDataChangeDelegate.swift
//  ToDo
//
//  Created by 段鸿易 on 12/9/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import Foundation

protocol TaskDataChangedDelegate {
    func peopleChanged(data: String) -> Void
    func endDateChanged(data: String) -> Void
    func tagChanged(data: String) -> Void
    func statusChanged(data: String) -> Void
}
