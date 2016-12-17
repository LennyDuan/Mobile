//
//  PeopleViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData
class PeopleSelectionViewController: SelectionDoneCancelViewController, UITableViewDataSource, UITableViewDelegate {

    func getItemArray() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "People")
        var array : NSArray = [People]() as NSArray
        do {
            array = try managedContext.fetch(fetchRequest) as! [People] as NSArray
        } catch {
            print("Error")
        }
        
        for item in array {
            items.append((item as AnyObject).name)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getItemArray()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "peopleSelectionCell")!
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = items[indexPath.row];
        dismiss(animated: true, completion: nil)
        delegate?.peopleChanged(tag)
    }
    
    
}
