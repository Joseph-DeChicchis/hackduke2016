//
//  BioTableViewCell.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

class BioTableViewCell: UITableViewCell {

    @IBOutlet var bioTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
