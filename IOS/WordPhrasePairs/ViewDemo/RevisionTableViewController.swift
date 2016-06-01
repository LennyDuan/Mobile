//
//  RevisionTableViewController.swift
//  ViewDemo
//
//  Created by 段鸿易 on 4/12/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class RevisionTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultController() ->NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "english", cacheName: nil)
        
        return frc
    }
    
    
    func listFetchRequest() ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "WordPhrasePair")
        let revisionPredicate = NSPredicate(format: "revision.revision == %@", "yes")
        fetchRequest.predicate = revisionPredicate

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
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // return frc.sections!.count
        return frc.sections!.count
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = frc.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    
    // List Cell Operation
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("revisionCell", forIndexPath: indexPath) as! myTableViewCell
        let list  = frc.objectAtIndexPath(indexPath) as! WordPhrasePair
        
        // Configure the cell...
        
        cell.englishLabel.text = list.english
        cell.welshLabel.text = list.welsh
        cell.noteLabel.text = list.note
        cell.typeLabel.text = list.type
        
        var all = " "
        for i  in list.tags! {
            all = all + " " + i.name!
        }
        cell.tagLabel.text = String(list.tags!.count) + " Tags: " + all
        return cell
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            let managedObject = frc.objectAtIndexPath(indexPath) as! WordPhrasePair
            managedObject.revision = nil

          //  let word  = frc.objectAtIndexPath(indexPath) as! WordPhrasePair
          //  word.revision?.revision = nil
            do {
                try context.save()
            } catch {
            }
            
            frc = getFetchedResultController()
            frc.delegate = self
            
            do {
                try frc.performFetch()
            } catch {
            }
            

        } else if editingStyle == .Insert {
            
        }
        
    }
   
}
