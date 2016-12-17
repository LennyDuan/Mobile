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
    
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var frc: NSFetchedResultsController<People>?
    func getFetchedResultController() -> NSFetchedResultsController<People> {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        return frc!
    }
    
    func listFetchRequest() ->NSFetchRequest<People> {
        let fetchRequest = NSFetchRequest<People>(entityName: "People")
        let sortDescriptor = NSSortDescriptor(key: "close", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    

    @IBAction func refreshTap(_ sender: Any) {
        tableView.reloadData()
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
            return self.filteredPeoplePairs.count
        }
        
        let section = frc!.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    
    // List Cell Operation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleCell", for: indexPath)
                
        if self.resultSearchController.isActive {
            cell.textLabel?.text = self.filteredPeoplePairs[indexPath.row].name!
            cell.detailTextLabel?.text = self.filteredPeoplePairs[indexPath.row].relation! + " -> " +
                String(self.filteredPeoplePairs[indexPath.row].tasks!.count) + " Tasks"

        } else {
            let list  = frc!.object(at: indexPath)
            var text = ""
//            if (list.close != nil) {
//                text += list.close! +  " - "
//            }
            text += list.name!
            text += " - "
            if (list.relation != nil) {
                text += list.relation!
            }
            cell.textLabel?.text = text

            var detail = "Total: "
            detail += String(list.tasks!.count) + " Tasks"
            
            let searchPredicate = NSPredicate(format: "self.status != %@", "Close")
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate])
            let array = list.tasks!.allObjects as NSArray
            let remainArray = array.filtered(using: predicate).count
            
            detail += "                                         -> Remain: " + "\(remainArray)" + " Tasks"
            cell.detailTextLabel?.text = detail

//          cell.detailTextLabel?.text = list.relation

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
                managedObject = filteredPeoplePairs[indexPath.row] as NSManagedObject
            }else {
                managedObject = frc!.object(at: indexPath)
            }
            context.delete(managedObject)
            do {
                try context.save()
            } catch {
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "edit"   {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let itemControler: PeopleTaskDisplayTableViewController = segue.destination as! PeopleTaskDisplayTableViewController
            
            if self.resultSearchController.isActive
            {
                let nItem: People = filteredPeoplePairs[(indexPath?.row)!]
                itemControler.nItem = nItem
            }else {
                let nItem: People = frc!.object(at: indexPath!)
                itemControler.nItem = nItem
            }
            
        }
    }

    // MARK: - Search View Controller
    
    var filteredPeoplePairs = [People]()
    var resultSearchController = UISearchController()
    
    
    func updateSearchResults(for searchController: UISearchController) {
        self.filteredPeoplePairs.removeAll(keepingCapacity: false)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<People>(entityName: "People")
        var array : NSArray = [People]() as NSArray
        do {
            array = try managedContext.fetch(fetchRequest) as NSArray
        } catch {
            print("Error")
        }
        
        let searchPredicate = NSPredicate(format: "(self.name CONTAINS[c] %@) OR (self.relation CONTAINS[c] %@)", searchController.searchBar.text!, searchController.searchBar.text!)
        filteredPeoplePairs = array.filtered(using: searchPredicate) as! [People]
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
