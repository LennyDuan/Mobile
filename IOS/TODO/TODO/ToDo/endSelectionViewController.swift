//
//  TagSelectionViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class endSelectionViewController: SelectionDoneCancelViewController, UIPickerViewDelegate {
    
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let today = NSDate()
    let formatter = NSDateFormatter();

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM dd YYYY EEE"
        startLabel.text = formatter.stringFromDate(today)
        endLabel.text = formatter.stringFromDate(today)
        dayLabel.text = "1 Days"
        datePicker.addTarget(self, action: #selector(endSelectionViewController.displayDate(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func dismissWithData(data: String) {
        dismissViewControllerAnimated(true, completion: nil)
        delegate?.endDateChanged(data)
    }
    
    @IBAction func confirmTap(sender: AnyObject){
        dismissWithData(endLabel.text!)
    }
    @IBAction func displayDate(sender: AnyObject) {
        formatter.dateFormat = "MMM dd YYYY EEE"
        endLabel.text = formatter.stringFromDate(datePicker.date)

        let currentCalendar = NSCalendar.currentCalendar()
        let timeUnitDay = NSCalendarUnit.Day
        let daysBetween = currentCalendar.components(timeUnitDay, fromDate: today, toDate: datePicker.date, options: NSCalendarOptions.MatchStrictly)
        let days = daysBetween.day
        
        dayLabel.text = "\(days) Days"
    }
}
