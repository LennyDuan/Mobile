//
//  SummaryViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/13/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit
import CoreData

class SummaryViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var totalTask: UILabel!
    @IBOutlet weak var totalDone: UILabel!
    @IBOutlet weak var totalNeed: UILabel!
    @IBOutlet weak var monthTask: UILabel!
    @IBOutlet weak var monthDone: UILabel!
    @IBOutlet weak var monthNeed: UILabel!
    @IBOutlet weak var dayTask: UILabel!
    @IBOutlet weak var dayDone: UILabel!
    @IBOutlet weak var dayNeed: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    
    @IBAction func refreshTap(sender: AnyObject) {
        setupSummary()
    }
    
    override func viewDidLoad() {
        setupSummary()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        
    }
    
    let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let fetchRequest = NSFetchRequest(entityName: "Task")
    var array : NSArray = [Task]()
    var currentDate : String = ""
    var dateArray : [String] = []
    var month : String = ""
    var year : String = ""
    func setupSummary() {
        do {
            array = try managedContext.executeFetchRequest(fetchRequest) as! [Task]
        } catch {
            print("Error")
        }
        
        currentDate = getDateString();
        todayLabel.text = currentDate
        
        dateArray = getDataArray(currentDate)
        month = dateArray[0]
        year = dateArray[2]

        setAllTask()
        setMonthTask(month, year: year)
        setTodayTask(currentDate)

    }
    
    let statusClosePredicate = NSPredicate(format: "self.status == %@", "Close")
    let statusOpenPredicate = NSPredicate(format: "self.status != %@", "Close")

    func setAllTask() {
        totalTask.text = "\(array.count)"
        
        var predicate = NSCompoundPredicate(notPredicateWithSubpredicate: statusOpenPredicate)
        totalNeed.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
        
        predicate = NSCompoundPredicate(notPredicateWithSubpredicate: statusClosePredicate)
        totalDone.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
    }
    
    func setMonthTask(month: String, year: String) {
        let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) AND (self.end CONTAINS[c] %@)", month, year)
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate])
        monthTask.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"

        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
        monthNeed.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusClosePredicate])
        monthDone.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
    }
    
    func setTodayTask(date: String) {
        let searchPredicate = NSPredicate(format: "self.end CONTAINS[c] %@", date)
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate])
        dayTask.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
        dayNeed.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusClosePredicate])
        dayDone.text =  "\(array.filteredArrayUsingPredicate(predicate).count)"
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "dayTask"   {
            let itemControler: PeopleTaskDisplayTableViewController = segue.destinationViewController as! PeopleTaskDisplayTableViewController
            
            array = array.filter() { $0.self.end == currentDate }
            itemControler.tasks = array as! [Task]
        } else if segue.identifier == "monthTask"   {
            
            let itemControler: PeopleTaskDisplayTableViewController = segue.destinationViewController as! PeopleTaskDisplayTableViewController
            
            let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) AND (self.end CONTAINS[c] %@)", month, year)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
            array = array.filteredArrayUsingPredicate(predicate)
            itemControler.tasks = array as! [Task]
        }
    }
    
    
    // Get Taday Date
    let dateFormatter = NSDateFormatter()
    func getDateString() -> String {
        let currentDate = NSDate()
        dateFormatter.locale = NSLocale.currentLocale()
        dateFormatter.dateFormat = "MMM dd YYYY EEE"
        return dateFormatter.stringFromDate(currentDate)
    }
    
    func getDataArray(array: String) -> [String] {
        return array.characters.split{$0 == " "}.map(String.init)
    }
}
