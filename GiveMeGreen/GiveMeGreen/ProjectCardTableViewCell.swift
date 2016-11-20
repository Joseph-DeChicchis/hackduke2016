//
//  ProjectCardTableViewCell.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/19/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

class ProjectCardTableViewCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var fundedLabel: UILabel!
    
    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var projectImageView: UIImageView!
    
    @IBOutlet var fundedProgressbar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
