//
//  myTableViewCell.swift
//  ViewDemo
//
//  Created by 段鸿易 on 4/12/16.
//  Copyright © 2016 Lenny. All rights reserved.
//

import UIKit

class myTableViewCell: UITableViewCell {

        @IBOutlet weak var englishLabel: UILabel!
   
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    
    @IBOutlet weak var welshLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
      
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
