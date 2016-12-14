//
//  TaskDisplayTableViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/13/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class PeopleTaskDisplayTableViewController: UITableViewController {
    
    
    // Core Data List View Initialize: Task
    
    var nItem: People? = nil
    var NStasks: NSSet? = nil
    var tasks: [Task] = []
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    // view Load
    override func viewDidLoad() {
        super.viewDidLoad()
        initList()
    }
    
    func initList() {
        if nItem != nil {
            let set = nItem?.tasks!
            tasks = set!.allObjects as! [Task]
        } else if NStasks != nil {
            tasks = NStasks!.allObjects as! [Task]
        }
        
        tasks = tasks.filter() { $0.self.status != "Close" }
        tasks = tasks.sort({ $0.priority > $1.priority })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    
    // List Cell Operation
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("peopleTaskListCell", forIndexPath: indexPath) as! ListTableViewCell
        
        let list  = tasks[indexPath.row]
        if ( list.title != nil) { cell.titleLabel?.text = list.title! }
        if ( list.end != nil) { cell.endLabel?.text = list.end! }
        if ( list.status != nil) { cell.statusLabel?.text = list.status! }
        if ( list.priority != nil) {
            cell.priorityLabel?.text = list.priority!
        }
        if ( list.people != nil) { cell.peopleLabel?.text = list.people?.name }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (nItem != nil) {
            if segue.identifier == "assignEdit"   {
                let itemControler: PeopleEditViewController = segue.destinationViewController as! PeopleEditViewController
                itemControler.nItem = nItem
            }
        } else if segue.identifier == "edit"   {
            let cell = sender as! ListTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let itemControler: TaskEditViewController = segue.destinationViewController as! TaskEditViewController
            
            let nItem: Task = tasks[(indexPath?.row)!]
            itemControler.nItem = nItem
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let managedObject: NSManagedObject
            
            managedObject = tasks[indexPath.row]
            
            
            let alert = UIAlertController(title: "关闭任务", message: "任务已完成，确认关闭", preferredStyle: UIAlertControllerStyle.Alert)
            let actionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { Void in
                self.closeTask(managedObject)
            }
            let actionCancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
            self.presentViewController(alert, animated: true, completion: nil)
            alert.addAction(actionYes)
            alert.addAction(actionCancel)
        }
    }
    
    func closeTask(managedObject: NSManagedObject) {
        managedObject.setValue("Close", forKey: "status")
        do {
            try context.save()
            initList()
            tableView.reloadData()
        } catch {
        }
    }
}
