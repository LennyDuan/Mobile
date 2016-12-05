//
//  PeopleTableViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/5/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class PeopleTableViewController: UITableViewController, NSFetchedResultsControllerDelegate,
    UISearchResultsUpdating
 {

    
    // Core Data List View Initialize: Assignee People
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    func getFetchedResultController() -> NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        return frc
    }
    
    func listFetchRequest() ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "People")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
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
            return self.filteredPeoplePairs.count
        }
        
        let section = frc.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    
    // List Cell Operation
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("peopleCell", forIndexPath: indexPath)
                
        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredPeoplePairs[indexPath.row].name!
            cell.detailTextLabel?.text = self.filteredPeoplePairs[indexPath.row].relation
        } else {
            let list  = frc.objectAtIndexPath(indexPath) as! People
            cell.textLabel?.text = list.name
            cell.detailTextLabel?.text = list.relation
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
                managedObject = filteredPeoplePairs[indexPath.row] as NSManagedObject
            }else {
                managedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
            }
            context.deleteObject(managedObject)
            do {
                try context.save()
            } catch {
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit"   {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let itemControler: PeopleEditViewController = segue.destinationViewController as! PeopleEditViewController
            
            if self.resultSearchController.active
            {
                let nItem: People = filteredPeoplePairs[(indexPath?.row)!]
                itemControler.nItem = nItem
            }else {
                let nItem: People = frc.objectAtIndexPath(indexPath!) as! People
                itemControler.nItem = nItem
            }
            
        }
    }

    // MARK: - Search View Controller
    
    var filteredPeoplePairs = [People]()
    var resultSearchController = UISearchController()
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredPeoplePairs.removeAll(keepCapacity: false)
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "People")
        var array : NSArray = [People]()
        do {
            array = try managedContext.executeFetchRequest(fetchRequest) as! [People]
        } catch {
            print("Error")
        }
        
        let searchPredicate = NSPredicate(format: "(self.name CONTAINS[c] %@) OR (self.relation CONTAINS[c] %@)", searchController.searchBar.text!, searchController.searchBar.text!)
        filteredPeoplePairs = array.filteredArrayUsingPredicate(searchPredicate) as! [People]
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
