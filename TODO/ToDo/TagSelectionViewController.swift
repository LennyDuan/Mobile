//
//  TagSelectionViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class TagSelectionViewController: SelectionDoneCancelViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            "Private",
            "Family",
            "Lover",
            "Work",
            "Friend",
            "School",
            "Agency",
            "Hospital",
            "Police",
            "Trade",
            "Bank",
            "Traval",
            "Others"
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tagSelectionCell")!
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = items[indexPath.row];
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.tagChanged(tag)
    }
}
