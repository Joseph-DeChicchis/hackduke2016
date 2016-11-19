//
//  ViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/19/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import MDCSwipeToChoose

import ZLSwipeableViewSwift

class ViewController: UIViewController { //, MDCSwipeToChooseDelegate {
    
    var count = -1
    
    let swipeableView = ZLSwipeableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swipeableView.allowedDirection = .All
        
        swipeableView.frame = CGRect(x: 20, y: 80, width: self.view.frame.width - 40, height: self.view.frame.height - 150)
        view.addSubview(swipeableView)
        
        swipeableView.numberOfActiveView = 2
        swipeableView.nextView = {
            self.count += 1
            let view = ProjectCardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 150))
            NSLog("Create view: \(self.count)")
            //return UIImageView(image: UIImage(named: "photo"))
            
            return view
        }
        swipeableView.loadViews()
        
        swipeableView.didStart = {view, location in
            print("Did start swiping view at location: \(location)")
        }
        swipeableView.swiping = {view, location, translation in
            print("Swiping at view location: \(location) translation: \(translation)")
        }
        swipeableView.didEnd = {view, location in
            print("Did end swiping view at location: \(location)")
        }
        swipeableView.didSwipe = {view, direction, vector in
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        swipeableView.didCancel = {view in
            print("Did cancel swiping view")
        }
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func swipeLeft(_ sender: Any) {
        swipeableView.swipeTopView(inDirection: .Left)
    }
    
    @IBAction func swipeRight(_ sender: Any) {
        swipeableView.swipeTopView(inDirection: .Right)
    }
    
    @IBAction func superLike(_ sender: Any) {
        swipeableView.swipeTopView(inDirection: .Up)
    }
    
}

