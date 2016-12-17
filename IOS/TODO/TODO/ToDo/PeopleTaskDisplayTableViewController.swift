//
//  TaskDisplayTableViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/13/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

class PeopleTaskDisplayTableViewController: UITableViewController {
    
    
    // Core Data List View Initialize: Task
    
    var nItem: People? = nil
    var NStasks: NSSet? = nil
    var tasks: [Task] = []
    var context: NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
        tasks = tasks.sorted(by: { $0.priority > $1.priority })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasks.count
    }
    
    
    // List Cell Operation
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleTaskListCell", for: indexPath) as! ListTableViewCell
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (nItem != nil) {
            if segue.identifier == "assignEdit"   {
                let itemControler: PeopleEditViewController = segue.destination as! PeopleEditViewController
                itemControler.nItem = nItem
            }
        } else if segue.identifier == "edit"   {
            let cell = sender as! ListTableViewCell
            let indexPath = tableView.indexPath(for: cell)
            
            let itemControler: TaskEditViewController = segue.destination as! TaskEditViewController
            
            let nItem: Task = tasks[(indexPath?.row)!]
            itemControler.nItem = nItem
            
        }
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let managedObject: NSManagedObject
            
            managedObject = tasks[indexPath.row]
            
            
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
            initList()
            tableView.reloadData()
        } catch {
        }
    }
}
