//
//  PeopleEditViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/5/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class PeopleEditViewController: CommonViewController, DataChangedDelegate{
    
    // Initiate UI
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var mobileEdit: UITextField!
    @IBOutlet weak var emailEdit: UITextField!
    @IBOutlet weak var relationEdit: UITextField!
    @IBOutlet weak var addressEdit: UITextField!
    
    // Close stepper select
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var closeEdit: UITextField!
    @IBAction func closeSteper(_ sender: AnyObject) {
        closeEdit.text = "\(Int(stepper.value))"
    }
    
    
    // Initiate
    
    let context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    var nItem: People? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.hideKeyboardWhenTappedArround()
        if nItem != nil {
            nameEdit.text = nItem?.name
            mobileEdit.text = nItem?.mobile
            emailEdit.text = nItem?.email
            relationEdit.text = nItem?.relation
            addressEdit.text = nItem?.address
            closeEdit.text = nItem?.close
            stepper.value = Double((nItem?.close)!)!
        }
        closeEdit.text = "\(Int(stepper.value))"
        relationEdit.text = "Manager"
        addressEdit.text = "UK"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // UI Bar button action
    
    @IBAction func cancelTap(_ sender: AnyObject) {
        self.view.endEditing(true)
        
//        let alert = UIAlertController(title: "Unsaved People", message: "Confirm Exit ?", preferredStyle: UIAlertControllerStyle.Alert)
//        let actionYes = UIAlertAction(title: "Exit", style: UIAlertActionStyle.Default) { Void in
            super.dismiss()
//        }
//        let actionCancel = UIAlertAction(title: "Remain", style: UIAlertActionStyle.Default, handler: nil)
//        self.presentViewController(alert, animated: true, completion: nil)
//        alert.addAction(actionYes)
//        alert.addAction(actionCancel)
    }
    @IBAction func saveTap(_ sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        super.dismiss()
    }
    
    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entity(forEntityName: "People", in: context)
        let nItem = People(entity: ent!, insertInto: context)
        
        let name = nameEdit.text
        
        do {
            if ((name!.isEmpty)) {
                let alert = UIAlertController(title: "Invalid Input", message: "Please Input Name", preferredStyle: UIAlertControllerStyle.alert)
                let actionCancel = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.default, handler: nil)
                self.present(alert, animated: true, completion: nil)
                alert.addAction(actionCancel)
                
            } else {
                nItem.setValue(nameEdit.text, forKey: "name")
                nItem.setValue(mobileEdit.text, forKey: "mobile")
                nItem.setValue(emailEdit.text, forKey: "email")
                nItem.setValue(relationEdit.text, forKey: "relation")
                nItem.setValue(addressEdit.text, forKey: "address")
                nItem.setValue(closeEdit.text, forKey: "close")
                try context.save()
            }
        }
        catch {
        }
    }
    
    func editItem() {
        nItem!.setValue(nameEdit.text, forKey: "name")
        nItem!.setValue(mobileEdit.text, forKey: "mobile")
        nItem!.setValue(emailEdit.text, forKey: "email")
        nItem!.setValue(relationEdit.text, forKey: "relation")
        nItem!.setValue(addressEdit.text, forKey: "address")
        nItem!.setValue(closeEdit.text, forKey: "close")

        do {
            try context.save()
        }
        catch {
        }
    }
    
    // Delegate Setting
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RelationSelectTableViewController {
            controller.delegate = self
        }
    }
    
    func dataChanged(_ data: [String]) {
        relationEdit.text = data.joined(separator: " / ")
    }
    
}

