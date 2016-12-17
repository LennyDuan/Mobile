//
//  TaskDataChangeDelegate.swift
//  ToDo
//
//  Created by 段鸿易 on 12/9/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import Foundation

protocol TaskDataChangedDelegate {
    func peopleChanged(_ data: String) -> Void
    func endDateChanged(_ data: String) -> Void
    func tagChanged(_ data: String) -> Void
    func statusChanged(_ data: String) -> Void
}
