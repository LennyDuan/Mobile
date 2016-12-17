//
//  TagSelectionViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class StatusSelectionViewController: SelectionDoneCancelViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            "Open",
            "Start - 25%",
            "In Process - 50%",
            "Almost Done - 75%",
            "Block",
            "Close"
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("statusSelectionCell")!
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let status = items[indexPath.row];
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.statusChanged(status)
    }
}
