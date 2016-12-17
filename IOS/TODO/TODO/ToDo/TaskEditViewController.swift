//
//  TaskEditViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/6/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class TaskEditViewController: UIViewController, TaskDataChangedDelegate {

    
    // Edit Init
    @IBOutlet weak var titleEdit: UITextField!
    @IBOutlet weak var peopleEdit: UITextField!
    @IBOutlet weak var startEdit: UITextField!
    @IBOutlet weak var endEdit: UITextField!
    @IBOutlet weak var tagEdit: UITextField!
    @IBOutlet weak var priorityEdit: UITextField!
    @IBOutlet weak var hardEdit: UITextField!
    @IBOutlet weak var statusEdit: UITextField!
    @IBOutlet weak var detailEdit: UITextView!
    
    // Stepper Init
    @IBOutlet weak var priorityStepper: UIStepper!
    @IBAction func priorityAction(sender: AnyObject) {
        priorityEdit.text = "\(Int(priorityStepper.value))"

    }
    
    @IBOutlet weak var hardStepper: UIStepper!
    @IBAction func hardAction(sender: AnyObject) {
        hardEdit.text = "\(Int(hardStepper.value))"
    }
    // SelectDelegate Init
    @IBOutlet weak var peopleSelectBtn: UIButton!
    @IBOutlet weak var endDateSelectBtn: UIButton!
    @IBOutlet weak var tagSelectBtn: UIButton!
    @IBOutlet weak var statusSelectBtn: UIButton!
    
    // Initiate
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var nItem: Task? = nil
    let formatter = NSDateFormatter();
    let today = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if nItem != nil {
            titleEdit.text = nItem?.title
            peopleEdit.text = nItem?.people?.name
            startEdit.text = nItem?.start
            endEdit.text = nItem?.end
            tagEdit.text = nItem?.tag
            priorityStepper.value = Double((nItem?.priority)!)!
            hardStepper.value = Double((nItem?.hard)!)!
            statusEdit.text = nItem?.status
            detailEdit.text = nItem?.detail

        } else {
            formatter.locale = NSLocale.currentLocale()
            formatter.dateFormat = "MMM dd YYYY EEE"
            startEdit.text = formatter.stringFromDate(today)
            endEdit.text = formatter.stringFromDate(today)
            tagEdit.text = "Work"
            statusEdit.text = "Open"
        }
        priorityEdit.text = "\(Int(priorityStepper.value))"
        hardEdit.text = "\(Int(hardStepper.value))"

    }
    
    func dismiss() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Save Tap
    @IBAction func saveTap(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        dismiss()
    }
    
    func fetchPeople() -> People {
        let context = self.context
        let fetchRequest = NSFetchRequest(entityName: "People")
        fetchRequest.predicate = NSPredicate(format: "name == %@", peopleEdit.text!)
        do {
       
        let objects = try context.executeFetchRequest(fetchRequest) as! [People]
        return objects[0]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("Task", inManagedObjectContext: context)
        let nItem = Task(entity: ent!, insertIntoManagedObjectContext: context)
        
        let title = titleEdit.text
        let people = peopleEdit.text
        
        do {
            if ((title!.isEmpty) || (people!.isEmpty) ) {
                let alert = UIAlertController(title: "Invalid Input", message: "Please Input Title && Assignee", preferredStyle: UIAlertControllerStyle.Alert)
                let actionCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: nil)
                self.presentViewController(alert, animated: true, completion: nil)
                alert.addAction(actionCancel)
                
            } else {
                
                nItem.setValue(titleEdit.text, forKey: "title")
                nItem.setValue(fetchPeople(), forKey: "people")
                nItem.setValue(startEdit.text, forKey: "start")
                nItem.setValue(endEdit.text, forKey: "end")
                nItem.setValue(tagEdit.text, forKey: "tag")
                nItem.setValue(priorityEdit.text, forKey: "priority")
                nItem.setValue(hardEdit.text, forKey: "hard")
                nItem.setValue(statusEdit.text, forKey: "status")
                nItem.setValue(detailEdit.text, forKey: "detail")
                
                try context.save()
                dismiss()
            }
        }
        catch {
        }
    }
    
    func editItem() {
        do {
            nItem!.setValue(titleEdit.text, forKey: "title")
            nItem!.setValue(fetchPeople(), forKey: "people")
            nItem!.setValue(startEdit.text, forKey: "start")
            nItem!.setValue(endEdit.text, forKey: "end")
            nItem!.setValue(tagEdit.text, forKey: "tag")
            nItem!.setValue(priorityEdit.text, forKey: "priority")
            nItem!.setValue(hardEdit.text, forKey: "hard")
            nItem!.setValue(statusEdit.text, forKey: "status")
            nItem!.setValue(detailEdit.text, forKey: "detail")
            try context.save()
        }
        catch {
        }
    }

    // Delegate
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let controller = segue.destinationViewController as? SelectionDoneCancelViewController {
            controller.delegate = self
        }
    }
    func peopleChanged(data: String) {
        peopleEdit.text = data
    }
    func endDateChanged(data: String) {
        endEdit.text = data
    }
    func tagChanged(data: String) {
        tagEdit.text = data
    }
    func statusChanged(data: String) {
        statusEdit.text = data
    }

}
