//
//  SelectionDoneCancelViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class SelectionDoneCancelViewController: UIViewController {
    var delegate: TaskDataChangedDelegate?
    var items: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelOperation() {
        dismiss(animated: true, completion: nil)
    }
}
