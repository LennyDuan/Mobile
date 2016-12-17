//
//  TaskListTableViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/10/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class TaskListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,
    UISearchResultsUpdating
{
    
    
    // Core Data List View Initialize: Task
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    func getFetchedResultController() -> NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc
    }
    
    func listFetchRequest() ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "status != %@", "Close" )

        return fetchRequest
    }
    
    // view Load
    override func viewDidLoad() {
        super.viewDidLoad()
        frc = getFetchedResultController()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
        }
        
        // Search bar
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        self.resultSearchController.searchBar.sizeToFit()

        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        self.tableView.reloadData()
    }
    

    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.resultSearchController.active
        {
            return 1
        }
        return frc.sections!.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active
        {
            return self.filteredTaskPairs.count
        }
        
        let section = frc.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    
    // List Cell Operation
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskListCell", forIndexPath: indexPath) as! ListTableViewCell
        
        if self.resultSearchController.active {
            cell.titleLabel?.text = self.filteredTaskPairs[indexPath.row].title!
            cell.endLabel?.text = self.filteredTaskPairs[indexPath.row].end!
            cell.statusLabel?.text = self.filteredTaskPairs[indexPath.row].status!
            cell.priorityLabel?.text = self.filteredTaskPairs[indexPath.row].priority!
            cell.peopleLabel?.text = self.filteredTaskPairs[indexPath.row].people?.name
            if ( self.filteredTaskPairs[indexPath.row].tag != nil) { cell.tagLabel?.text = self.filteredTaskPairs[indexPath.row].tag! + ": "  }
        } else {
            let list  = frc.objectAtIndexPath(indexPath) as! Task
            if ( list.title != nil) { cell.titleLabel?.text = list.title! }
            if ( list.end != nil) { cell.endLabel?.text = list.end! }
            if ( list.status != nil) { cell.statusLabel?.text = list.status! }
            if ( list.priority != nil) {
//                if ( list.tag != nil)  {
//                    cell.priorityLabel?.text = list.priority! + " -> " + list.tag!
//                }
                cell.priorityLabel?.text = list.priority!
            }
            if ( list.people != nil) { cell.peopleLabel?.text = list.people?.name }
            if ( list.tag != nil) { cell.tagLabel?.text = list.tag! + ": " }
        }
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let managedObject: NSManagedObject
            if self.resultSearchController.active
            {
                managedObject = filteredTaskPairs[indexPath.row] as NSManagedObject
            }else {
                managedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
            }
            
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
        } catch {
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit"   {
            let cell = sender as! ListTableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let itemControler: TaskEditViewController = segue.destinationViewController as! TaskEditViewController
            
            if self.resultSearchController.active
            {
                let nItem: Task = filteredTaskPairs[(indexPath?.row)!]
                itemControler.nItem = nItem
            }else {
                let nItem: Task = frc.objectAtIndexPath(indexPath!) as! Task
                itemControler.nItem = nItem
            }
            
        }
    }
    
    // MARK: - Search View Controller
    
    var filteredTaskPairs = [Task]()
    var resultSearchController = UISearchController()
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredTaskPairs.removeAll(keepCapacity: false)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: "Task")

        var array : NSArray = [Task]()
        do {
            array = try managedContext.executeFetchRequest(fetchRequest) as! [Task]
        } catch {
            print("Error")
        }

        let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) OR (self.tag CONTAINS[c] %@)", searchController.searchBar.text!, searchController.searchBar.text!)
        let statuPredicate = NSPredicate(format: "(self.status != %@)",  "Close", searchController.searchBar.text!, searchController.searchBar.text!)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statuPredicate])
        
        let priorityDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        let endDescriptor = NSSortDescriptor(key: "end", ascending: true)

        fetchRequest.sortDescriptors = [priorityDescriptor, endDescriptor]

        filteredTaskPairs = array.filteredArrayUsingPredicate(predicate) as! [Task]
        self.definesPresentationContext = true
        self.tableView.reloadData()
    }
    
    // Delete All contacts data
    
    //    @IBAction func deleteData(sender: AnyObject) {
    //
    //        let alert = UIAlertController(title: "Clean All Assignees?", message: "Are you sure to delete all contacts data? ", preferredStyle: UIAlertControllerStyle.Alert)
    //        let actionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { Void in
    //            self.deleteAllData("People")
    //        }
    //        let actionCancel = UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil)
    //        self.presentViewController(alert, animated: true, completion: nil)
    //        alert.addAction(actionYes)
    //        alert.addAction(actionCancel)
    //    }
    //
    //
    //    func deleteAllData(entity: String)
    //    {
    //        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    //        let managedContext = appDelegate.managedObjectContext
    //        let fetchRequest = NSFetchRequest(entityName: entity)
    //        fetchRequest.returnsObjectsAsFaults = false
    //        do
    //        {
    //            let results = try managedContext.executeFetchRequest(fetchRequest)
    //            for managedObject in results
    //            {
    //                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
    //                managedContext.deleteObject(managedObjectData)
    //            }
    //        } catch let error as NSError {
    //            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
    //        }
    //    }
}
