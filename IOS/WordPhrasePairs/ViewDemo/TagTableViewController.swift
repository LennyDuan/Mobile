//
//  TagTableViewController.swift
//  ViewDemo
//
//  Created by 段鸿易 on 3/24/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class TagTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var frc: NSFetchedResultsController = NSFetchedResultsController()
    
    func getFetchedResultController() ->NSFetchedResultsController {
        frc = NSFetchedResultsController(fetchRequest: tagFetchRequest(), managedObjectContext: context, sectionNameKeyPath: "name", cacheName: nil)
        return frc
    }
    
    func tagFetchRequest() ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Tag")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add add button on the navigation right
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TagTableViewController.addTag))
        
        frc = getFetchedResultController()
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
        }


    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return frc.sections!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let indexPath = NSIndexPath(forRow: 0, inSection: section)
        let tag = frc.objectAtIndexPath(indexPath) as! Tag
        let titleForSection = tag.name!.uppercaseString
        return titleForSection
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        let section = frc.sections![section] as NSFetchedResultsSectionInfo
        return section.numberOfObjects
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tagCell", forIndexPath: indexPath)
        let list  = frc.objectAtIndexPath(indexPath) as! Tag
        cell.textLabel?.text = list.name
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let managedObject: NSManagedObject = frc.objectAtIndexPath(indexPath) as! NSManagedObject
            context.deleteObject(managedObject)
            do {
                try context.save()
            } catch {
                
            }
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "tagWords"   {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            
            let itemControler = segue.destinationViewController as! TagWordTableViewController
            
            let nItem: Tag = frc.objectAtIndexPath(indexPath!) as! Tag
            
            itemControler.nItem = nItem
            
        }
        
    
    }
    

    
    
    
    // Create a new tag and save
    func addTag() {
        
        let alertController = UIAlertController(title: "Add Tag", message: nil,  preferredStyle: .Alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: ({
            (_) in
            if let field = alertController.textFields![0] as? UITextField {
                self.saveTag(field.text!)
                self.tableView.reloadData()
            }
            }
        ))
        
        let cancelAction  = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alertController.addTextFieldWithConfigurationHandler({
            (textField) in
            textField.placeholder = "Input"
        })
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    func saveTag(itemToSave : String) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let entity = NSEntityDescription.entityForName("Tag", inManagedObjectContext: managedContext)
        let item = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        item.setValue(itemToSave, forKey: "name")
        do {
            try managedContext.save()
        }
        catch {
            print("error")
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
}
