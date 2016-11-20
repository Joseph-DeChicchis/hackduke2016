//
//  Project.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/19/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

class Project: NSObject {

    var name = ""
    var title = ""
    var walletAddress = ""
    var imageURL = ""
    var totalAmount = 0.0
    var currentAmount = 0.0
    
    func setup(infoDic: NSDictionary) {
        
        name = infoDic.value(forKey: "name") as! String
        title = infoDic.value(forKey: "title") as! String
        walletAddress = infoDic.value(forKey: "walletAddress") as! String
        imageURL = infoDic.value(forKey: "imageURL") as! String
        totalAmount = infoDic.value(forKey: "totalAmount") as! Double
        currentAmount = infoDic.value(forKey: "currentAmount") as! Double
        
    }
    
}
