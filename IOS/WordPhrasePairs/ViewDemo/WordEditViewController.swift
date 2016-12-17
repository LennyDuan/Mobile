//
//  WordEditViewController.swift
//  ViewDemo
//
//  Created by 段鸿易 on 3/22/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class WordEditViewController: UIViewController, UIPickerViewDelegate {
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var nItem: WordPhrasePair? = nil
   
    @IBOutlet weak var entryEnglish: UITextField!
    @IBOutlet weak var entryNote: UITextField!
    @IBOutlet weak var entryType: UITextField!
    @IBOutlet weak var entryWelsh: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        if nItem != nil {
            entryEnglish.text = nItem?.english
            entryNote.text = nItem?.note
            entryType.text = nItem?.type
            entryWelsh.text = nItem?.welsh
            
            addTagController()

        }
        
        // Test - print(nItem?.revision?.revision)

    }

    // MARK: - New or Edit WordPhrasePair **************************************//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func dismiss() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    @IBAction func saveTapped(sender: AnyObject) {
        if nItem != nil {
            editItem()
        } else {
            newItem()
        }
        dismiss()
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let  managedContext = appDelegate.managedObjectContext
        
        let wordFetch = NSFetchRequest(entityName: "WordPhrasePair")
        
        do {
            let wordList = try managedContext.executeFetchRequest(wordFetch)
      //Log - Test      print(wordList.count)
        } catch {
            print("Error")
        }
        
        dismiss()
    }

    func newItem() {
        let context = self.context
        let ent = NSEntityDescription.entityForName("WordPhrasePair", inManagedObjectContext: context)
        let nItem = WordPhrasePair(entity: ent!, insertIntoManagedObjectContext: context)
        
        nItem.setValue(entryEnglish.text, forKey: "english")
        nItem.setValue(entryWelsh.text, forKey: "welsh")
        nItem.setValue(entryNote.text, forKey: "note")
        nItem.setValue(entryType.text, forKey: "type")

        do {
            try context.save()
        }
        catch {
        }
        
    }
    
    func editItem() {
        nItem!.setValue(entryEnglish.text, forKey: "english")
        nItem!.setValue(entryWelsh.text, forKey: "welsh")
        nItem!.setValue(entryNote.text, forKey: "note")
        nItem!.setValue(entryType.text, forKey: "type")
        do {
            try context.save()
        }
        catch {
        }
    }
    
    // MARK: - Add Tag To Word **************************************//

    @IBOutlet weak var tagDetails: UILabel!
    @IBAction func pickerConfirm(sender: AnyObject) {
       
    }
    @IBOutlet weak var picker: UIPickerView!


    var list = []
    var tags = [Tag]()
    var managedContext: NSManagedObjectContext! = nil
 
    func addTagController() {
        picker.delegate = self

        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        let tagFetch = NSFetchRequest(entityName: "Tag")
        
        do {
            list = try managedContext.executeFetchRequest(tagFetch)
        } catch  {
            print("Error")
        }
        
        var all = " "
        for i  in (nItem?.tags)! {
            tags.append(i as! Tag)
            all = all + " " + (i as! Tag).name!
        }
        tagDetails.text = (nItem?.tags?.count.description)! + " Tags: " + all
    }
    
    
    // MARK: - Picker Set Up**************************************//


    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row].name
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        var same = false
        for i  in tags {
            if i == list[row] as! Tag {
                same = true
            }
        }
    
        if same == false {
        tags.append(list[row] as! Tag)
        var all = " "
        for i  in tags {
            all = all + " " + i.name!
        }
        tagDetails.text  = String(tags.count) + " Tags: " + all
        }
        
        if nItem != nil {
        let addTag : Tag
        addTag = list[row] as! Tag
 
  //Log Test - print(String(addTag.wordPairs?.count) + "!!!")

        let t = nItem?.tags!.mutableCopy() as! NSMutableSet
        t.addObject(addTag)
        nItem?.tags = t as NSSet
            
        do {
            try context.save()
  //Log Test         print(nItem!.tags!.count)
           } catch let error as NSError {
            print("Cannot save talk data, error: \(error)")
           }
        }

    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    
    // MARK: - Add Word To Revision
    
    
    @IBAction func addToRevision(sender: AnyObject) {
        
        if nItem != nil {
        if nItem?.revision?.revision != "yes"{
            
        let context = self.context
        let ent = NSEntityDescription.entityForName("Revision", inManagedObjectContext: context)
        let revision = Revision(entity: ent!, insertIntoManagedObjectContext: context)
    
        revision.setValue("yes", forKey: "revision")
        nItem?.revision = revision
        do {
            try context.save()
        } catch let error as NSError {
            print("Cannot save talk data, error: \(error)")
        }
        }
    
       // Test - print((nItem?.revision?.revision)! + "!!")
        }

    }


}
