//
//  RelationSelectTableViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/7/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class RelationSelectTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var delegate: DataChangedDelegate?
    
    var items: [RelationItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            RelationItem(data: "Family"),
            RelationItem(data: "Lover"),
            RelationItem(data: "Friend"),
            RelationItem(data: "Leader"),
            RelationItem(data: "Manager"),
            RelationItem(data: "Customer"),
            RelationItem(data: "Colleague"),
            RelationItem(data: "Teacher"),
            RelationItem(data: "Intermediary"),
            RelationItem(data: "Acquaintance"),
            RelationItem(data: "Employee"),
            RelationItem(data: "Stranger"),
            RelationItem(data: "Others")
        ]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("relationSelectCell", forIndexPath: indexPath)
        
        cell.textLabel!.text = items[indexPath.row].data
        if items[indexPath.row].selected {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        items[indexPath.row].selected = !(items[indexPath.row].selected)
        tableView.reloadData()
    }

    
    @IBAction func doneTap(sender: AnyObject) {
        dismissWithData(items)
    }
    @IBAction func cancelTap(sender: AnyObject) {
        dismissWithData([])
    }
    
    func dismissWithData(data: [RelationItem]) {
        dismissViewControllerAnimated(true, completion: nil)
        let content = items.filter({$0.selected}).map({selected in selected.data!})
        delegate?.dataChanged(content)
    }
    
}
