//
//  CustomTableViewCell.swift
//  ToDoList
//
//  Created by Bherly Novrandy on 5/3/17.
//  Copyright © 2017 Bherly Novrandy. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var myCustomLabel: UILabel!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
