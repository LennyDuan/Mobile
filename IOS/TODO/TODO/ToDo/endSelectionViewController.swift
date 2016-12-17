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
    
    let today = Date()
    let formatter = DateFormatter();

    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "MMM dd YYYY EEE"
        startLabel.text = formatter.string(from: today)
        endLabel.text = formatter.string(from: today)
        dayLabel.text = "1 Days"
        datePicker.addTarget(self, action: #selector(endSelectionViewController.displayDate(_:)), for: UIControlEvents.valueChanged)
    }
    
    func dismissWithData(_ data: String) {
        dismiss(animated: true, completion: nil)
        delegate?.endDateChanged(data)
    }
    
    @IBAction func confirmTap(_ sender: AnyObject){
        dismissWithData(endLabel.text!)
    }
    @IBAction func displayDate(_ sender: AnyObject) {
        formatter.dateFormat = "MMM dd YYYY EEE"
        endLabel.text = formatter.string(from: datePicker.date)

        let currentCalendar = Calendar.current
        let timeUnitDay = NSCalendar.Unit.day
        let daysBetween = (currentCalendar as NSCalendar).components(timeUnitDay, from: today, to: datePicker.date, options: NSCalendar.Options.matchStrictly)
        var days : Int
        days = daysBetween.day!
        
        dayLabel.text = "\(days) Days"
    }
}
