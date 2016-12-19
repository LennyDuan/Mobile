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
    
    @IBAction func refreshTap(_ sender: AnyObject) {
        setupSummary()
    }
    
    override func viewDidLoad() {
        setupSummary()
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
    var array : NSArray = [Task]() as NSArray
    var currentDate : String = ""
    var dateArray : [String] = []
    var month : String = ""
    var year : String = ""
    func setupSummary() {
        do {
            array = try managedContext.fetch(fetchRequest) as! [Task] as NSArray
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
        
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusOpenPredicate])
        totalNeed.text =  "\(array.filtered(using: predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusClosePredicate])
        totalDone.text =  "\(array.filtered(using: predicate).count)"
    }
    
    func setMonthTask(_ month: String, year: String) {
        let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) AND (self.end CONTAINS[c] %@)", month, year)
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate])
        monthTask.text =  "\(array.filtered(using: predicate).count)"

        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
        monthNeed.text =  "\(array.filtered(using: predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusClosePredicate])
        monthDone.text =  "\(array.filtered(using: predicate).count)"
    }
    
    func setTodayTask(_ date: String) {
        let searchPredicate = NSPredicate(format: "self.end CONTAINS[c] %@", date)
        var predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate])
        dayTask.text =  "\(array.filtered(using: predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
        dayNeed.text =  "\(array.filtered(using: predicate).count)"
        
        predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusClosePredicate])
        dayDone.text =  "\(array.filtered(using: predicate).count)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dayTask"   {
            let itemControler: PeopleTaskDisplayTableViewController = segue.destination as! PeopleTaskDisplayTableViewController

            
            let searchPredicate = NSPredicate(format: "self.end CONTAINS[c] %@", currentDate)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])

            array = array.filtered(using: predicate) as NSArray
            itemControler.tasks = array as! [Task]
        } else if segue.identifier == "monthTask"   {
            
            let itemControler: PeopleTaskDisplayTableViewController = segue.destination as! PeopleTaskDisplayTableViewController
            
            let searchPredicate = NSPredicate(format: "(self.end CONTAINS[c] %@) AND (self.end CONTAINS[c] %@)", month, year)
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [searchPredicate, statusOpenPredicate])
            array = array.filtered(using: predicate) as NSArray
            itemControler.tasks = array as! [Task]
        }
    }
    
    
    // Get Taday Date
    let dateFormatter = DateFormatter()
    func getDateString() -> String {
        let currentDate = Date()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "MMM dd YYYY EEE"
        return dateFormatter.string(from: currentDate)
    }
    
    func getDataArray(_ array: String) -> [String] {
        return array.characters.split{$0 == " "}.map(String.init)
    }
}
