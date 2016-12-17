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
    @IBAction func priorityAction(_ sender: AnyObject) {
        priorityEdit.text = "\(Int(priorityStepper.value))"

    }
    
    @IBOutlet weak var hardStepper: UIStepper!
    @IBAction func hardAction(_ sender: AnyObject) {
        hardEdit.text = "\(Int(hardStepper.value))"
    }
    // SelectDelegate Init
    @IBOutlet weak var peopleSelectBtn: UIButton!
    @IBOutlet weak var endDateSelectBtn: UIButton!
    @IBOutlet weak var tagSelectBtn: UIButton!
    @IBOutlet weak var statusSelectBtn: UIButton!
    
    // Initiate
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var nItem: Task? = nil
    let formatter = DateFormatter();
    let today = Date()

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
            formatter.locale = Locale.current
            formatter.dateFormat = "MMM dd YYYY EEE"
            startEdit.text = formatter.string(from: today)
            endEdit.text = formatter.string(from: today)
            tagEdit.text = "Work"
            statusEdit.text = "Open"
        }
        priorityEdit.text = "\(Int(priorityStepper.value))"
        hardEdit.text = "\(Int(hardStepper.value))"

    }
    
    func dismiss() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Save Tap
    @IBAction func saveTap(_ sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        dismiss()
    }
    
    func fetchPeople() -> People {
        let context = self.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        fetchRequest.predicate = NSPredicate(format: "name == %@", peopleEdit.text!)
        do {
       
        let objects = try context.fetch(fetchRequest) as! [People]
        return objects[0]
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let nItem = Task(entity: ent!, insertInto: context)
        
        let title = titleEdit.text
        let people = peopleEdit.text
        
        do {
            if ((title!.isEmpty) || (people!.isEmpty) ) {
                let alert = UIAlertController(title: "Invalid Input", message: "Please Input Title && Assignee", preferredStyle: UIAlertControllerStyle.alert)
                let actionCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil)
                self.present(alert, animated: true, completion: nil)
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? SelectionDoneCancelViewController {
            controller.delegate = self
        }
    }
    func peopleChanged(_ data: String) {
        peopleEdit.text = data
    }
    func endDateChanged(_ data: String) {
        endEdit.text = data
    }
    func tagChanged(_ data: String) {
        tagEdit.text = data
    }
    func statusChanged(_ data: String) {
        statusEdit.text = data
    }

}
