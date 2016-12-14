//
//  PeopleViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class PeopleSelectionViewController: SelectionDoneCancelViewController, UITableViewDataSource, UITableViewDelegate {

    func getItemArray() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "People")
        var array : NSArray = [People]()
        do {
            array = try managedContext.executeFetchRequest(fetchRequest) as! [People]
        } catch {
            print("Error")
        }
        
        for item in array {
            items.append(item.name)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemArray()
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("peopleSelectionCell")!
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tag = items[indexPath.row];
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.peopleChanged(tag)
    }
    
    
}
