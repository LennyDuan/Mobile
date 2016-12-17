//
//  WordPairsTableViewController.swift
//  ViewDemo
//
//  Created by 段鸿易 on 3/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class WordPairsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating

{
    // Mark: - Core Data List View Initialize: WordPhrasePair
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultController() ->NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "english", cacheName: nil)
        
        return frc
    }
    
    func listFetchRequest() ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "WordPhrasePair")
        let sortDescriptor = NSSortDescriptor(key: "english", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        frc = getFetchedResultController()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
        }
 
        // Search
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

    /*
    override func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
              return index
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let wordPairs = frc.objectAtIndexPath(indexPath) as! WordPhrasePair
        let index = wordPairs.english!.startIndex.advancedBy(1)
        let titleForSection = wordPairs.english!.substringToIndex(index).uppercaseString
  
        return titleForSection

    }
    
    */
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       // return frc.sections!.count
        if self.resultSearchController.active
        {
            return 1
        }

        return frc.sections!.count
    }
    

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.resultSearchController.active
        {
            return self.filteredWordPairs.count
        }
        
        let section = frc.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }

    
    // List Cell Operation
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("wordCell", forIndexPath: indexPath)

        if self.resultSearchController.active {
            cell.textLabel?.text = self.filteredWordPairs[indexPath.row].english
            cell.detailTextLabel?.text = self.filteredWordPairs[indexPath.row].welsh

        } else {
            let list  = frc.objectAtIndexPath(indexPath) as! WordPhrasePair
            cell.textLabel?.text = list.english
            cell.detailTextLabel?.text = list.welsh
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
                 managedObject = filteredWordPairs[indexPath.row] as NSManagedObject
            }else {
             managedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
            }
            context.deleteObject(managedObject)
            do {
                try context.save()
            } catch {
            }
        } else if editingStyle == .Insert {
            
        }
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "edit"   {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let itemControler: WordEditViewController = segue.destinationViewController as! WordEditViewController
            
            if self.resultSearchController.active
            {
            let nItem: WordPhrasePair = filteredWordPairs[(indexPath?.row)!] 
                itemControler.nItem = nItem
            }else {
            let nItem: WordPhrasePair = frc.objectAtIndexPath(indexPath!) as! WordPhrasePair
            itemControler.nItem = nItem
            }
            
        }
    }
    
    // MARK: - Search View Controller

    var filteredWordPairs = [WordPhrasePair]()
    var resultSearchController = UISearchController()
    
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filteredWordPairs.removeAll(keepCapacity: false)
  
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "WordPhrasePair")
        var array : NSArray = [WordPhrasePair]()
            do {
                array = try managedContext.executeFetchRequest(fetchRequest) as! [WordPhrasePair]

                //Log - Test      print(wordList.count)
            } catch {
                print("Error")
            }
        
        let searchPredicate = NSPredicate(format: "self.english CONTAINS[c] %@", searchController.searchBar.text!)
        filteredWordPairs = array.filteredArrayUsingPredicate(searchPredicate) as! [WordPhrasePair]
        self.definesPresentationContext = true
        self.tableView.reloadData()
        
    }
    
    
}
