//
//  TagSelectionViewController.swift
//  ToDo
//
//  Created by 段鸿易 on 12/11/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class TagSelectionViewController: SelectionDoneCancelViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = [
            "Private",
            "Family",
            "Lover",
            "Work",
            "Friend",
            "School",
            "Agency",
            "Hospital",
            "Police",
            "Trade",
            "Bank",
            "Traval",
            "Others"
        ]
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagSelectionCell")!
        cell.textLabel!.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = items[indexPath.row];
        dismiss(animated: true, completion: nil)
        delegate?.tagChanged(tag)
    }
}
