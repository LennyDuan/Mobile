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
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController<Task>?
    func getFetchedResultController() -> NSFetchedResultsController<Task> {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return frc!
    }
    
    func listFetchRequest() ->NSFetchRequest<Task> {
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")
        let sortDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "status != %@", "Close" )

        return fetchRequest
    }
    
    // view Load
    override func viewDidLoad() {
        super.viewDidLoad()
        frc = getFetchedResultController()
        frc!.delegate = self
        
        do {
            try frc!.performFetch()
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
    

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.resultSearchController.isActive
        {
            return 1
        }
        return frc!.sections!.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.isActive
        {
            return self.filteredTaskPairs.count
        }
        
        let section = frc!.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    
    // List Cell Operation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskListCell", for: indexPath) as! ListTableViewCell
        
        if self.resultSearchController.isActive {
            cell.titleLabel?.text = self.filteredTaskPairs[indexPath.row].title!
            cell.endLabel?.text = self.filteredTaskPairs[indexPath.row].end!
            cell.statusLabel?.text = self.filteredTaskPairs[indexPath.row].status!
            cell.priorityLabel?.text = self.filteredTaskPairs[indexPath.row].priority!
            cell.peopleLabel?.text = self.filteredTaskPairs[indexPath.row].people?.name
            if ( self.filteredTaskPairs[indexPath.row].tag != nil) { cell.tagLabel?.text = self.filteredTaskPairs[indexPath.row].tag! + ": "  }
        } else {
            let list  = frc!.object(at: indexPath)
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let managedObject: NSManagedObject
            if self.resultSearchController.isActive
            {
                managedObject = filteredTaskPairs[indexPath.row] as NSManagedObject
            }else {
                managedObject = frc!.object(at: indexPath)
            }
            
            let alert = UIAlertController(title: "关闭任务", message: "任务已完成，确认关闭", preferredStyle: UIAlertControllerStyle.alert)
            let actionYes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default) { Void in
                self.closeTask(managedObject)
            }
            let actionCancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            self.present(alert, animated: true, completion: nil)
            alert.addAction(actionYes)
            alert.addAction(actionCancel)
        }
        
    }
    func closeTask(_ managedObject: NSManagedObject) {
        managedObject.setValue("Close", forKey: "status")
        do {
            try context.save()
        } catch {
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"   {
            let cell = sender as! ListTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let itemControler: TaskEditViewController = segue.destination as! TaskEditViewController
            
            if self.resultSearchController.isActive
            {
                let nItem: Task = filteredTaskPairs[(indexPath?.row)!]
                itemControler.nItem = nItem
            }else {
                let nItem: Task = frc!.object(at: indexPath!)
                itemControler.nItem = nItem
            }
            
        }
    }
    
    // MARK: - Search View Controller
    
    var filteredTaskPairs = [Task]()
    var resultSearchController = UISearchController()
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredTaskPairs.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let fetchRequest = NSFetchRequest<Task>(entityName: "Task")

        var array : NSArray = [Task]() as NSArray
        do {
            array = try managedContext.fetch(fetchRequest) as NSArray
        } catch {
            print("Error")
        }

        let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) OR (self.tag CONTAINS[c] %@) OR (self.title CONTAINS[c] %@)", searchController.searchBar.text!, searchController.searchBar.text!, searchController.searchBar.text!)
        let statuPredicate = NSPredicate(format: "(self.status != %@)",  "Close", searchController.searchBar.text!, searchController.searchBar.text!)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statuPredicate])
        
        let priorityDescriptor = NSSortDescriptor(key: "priority", ascending: false)
        let endDescriptor = NSSortDescriptor(key: "end", ascending: true)

        fetchRequest.sortDescriptors = [priorityDescriptor, endDescriptor]

        filteredTaskPairs = array.filtered(using: predicate) as! [Task]
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
