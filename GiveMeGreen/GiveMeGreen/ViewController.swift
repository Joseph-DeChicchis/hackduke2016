//
//  ViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/19/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import ZLSwipeableViewSwift

import Firebase

class ViewController: UIViewController {
    
    @IBOutlet var selectionLabel: UILabel!
    
    var count = 0
    
    let swipeableView = ZLSwipeableView()
    
    var projectArray = Array<Project>()
    
    var rawProjects = Array<AnyObject>()
    
    var emailAddress = ""
    
    var uid = ""
    
    var userProjects = Array<String>()
    
    var swipeCount = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        swipeableView.allowedDirection = .All
        
        swipeableView.frame = CGRect(x: 20, y: 80, width: self.view.frame.width - 40, height: self.view.frame.height - 175)
        view.addSubview(swipeableView)
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                
                NSLog("signed in")
                
                self.emailAddress = user!.email!
                
                self.uid = user!.uid
                
                let ref = FIRDatabase.database().reference()
                
                ref.child("userProjects/\(self.uid)").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        NSLog("userProjects: \(snapshot)")
                        
                        self.userProjects = snapshot.value  as! Array<String>
                        
                    }
                    
                }) { (error) in
                    NSLog(error.localizedDescription)
                }
                
            } else {
                // No user is signed in.
                
                NSLog("not signed in", [])
                
                self.emailAddress = ""
            }
        }
        
        selectionLabel.isHidden = true
        self.view.bringSubview(toFront: selectionLabel)
        
        swipeableView.didSwipe = {view, direction, vector in
            
            self.swipeCount = self.swipeCount + 1
            
            self.notifySelection(direction: "\(direction)")
            
            self.handleSwipe(direction: "\(direction)", index: self.swipeCount % self.projectArray.count)
        }
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("projects").observe(.value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                self.rawProjects = (snapshot.value as! NSDictionary).allValues as Array<AnyObject>
                
                self.processProjects()
                
            }
            
        }) { (error) in
            NSLog(error.localizedDescription)
        }

        
    }
    
    func processProjects() {
        /*
        let project1 = Project()
        project1.setup(infoDic: ["name": "John Smith", "title": "This is cool!", "walletAddress": "walletAddress", "imageURL": "imageURL", "totalAmount": 15.0, "currentAmount": 12.0])
        
        let project2 = Project()
        project2.setup(infoDic: ["name": "Samantha Jenny", "title": "Awesome!", "walletAddress": "walletAddress", "imageURL": "imageURL", "totalAmount": 10.0, "currentAmount": 3.0])
        
        projectArray.append(project1)
        projectArray.append(project2)*/
        
        NSLog("processProjects")
        
        projectArray.removeAll()
        
        for project: AnyObject in rawProjects {
            let dic = project as! NSDictionary
            let temp = Project()
            temp.setup(infoDic: ["name": dic.value(forKey: "Name") as! String, "title": dic.value(forKey: "Title") as! String, "walletAddress": dic.value(forKey: "walletId") as! String, "imageURL": dic.value(forKey: "Picture") as! String, "totalAmount": dic.value(forKey: "Goal") as! Double, "currentAmount": dic.value(forKey: "Donated") as! Double, "bio": dic.value(forKey: "Bio") as! String, "projectID": dic.value(forKey: "projectID") as! String])
            
            projectArray.append(temp)
        }
        
        NSLog("projectArray: \(projectArray)")
        
        swipeableView.numberOfActiveView = 2
        swipeableView.nextView = {
            NSLog("nextView")
            if self.count >= self.projectArray.count {
                self.count = 0
            }
            
            if self.projectArray.count == 0 {
                self.count += 1
                return UIView()
            }
            
            let view = ProjectCardView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - 40, height: self.view.frame.height - 175))
            NSLog("Create view: \(self.count)")
            
            view.setProject(project: self.projectArray[self.count])
            
            self.count += 1
            return view
        }
        swipeableView.loadViews()
    }
    
    func notifySelection(direction: String) {
        if direction == "Up" {
            selectionLabel.textColor = UIColor.blue
            
            selectionLabel.text = "Super Like!"
        }
        else if direction == "Right" {
            selectionLabel.textColor = UIColor.green
            
            selectionLabel.text = "Like"
        }
        else {
            selectionLabel.textColor = UIColor.red
            
            selectionLabel.text = "Nah"
        }
        
        selectionLabel.isHidden = false
        
        selectionLabel.alpha = 0.0
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
            
            self.selectionLabel.alpha = 0.75
            
        }, completion: { _ in
            UIView.animate(withDuration: 0.25, delay: 0.0, options: [.curveEaseOut], animations: {
                
                self.selectionLabel.alpha = 0.0
                
            }, completion: { _ in
                
                self.selectionLabel.isHidden = true
                
            })
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSwipe(direction: String, index: Int) {
        if direction == "Up" {
            var request = URLRequest(url: URL(string: "https://hackduke2016.herokuapp.com/fundProject?acct_id=\(projectArray[index].walletAddress)&email=\(emailAddress)&amount=1")!)
            request.httpMethod = "GET"
            let session = URLSession.shared
            
            session.dataTask(with: request) {data, response, err in
                NSLog("SUPERLIKE: \(response)")
                }.resume()
        }
        else if direction == "Right" {
            
            if !userProjects.contains(projectArray[index].projectID) {
                userProjects.append(projectArray[index].projectID)
                
                let ref = FIRDatabase.database().reference()
                
                ref.child("userProjects/\(uid)").setValue(userProjects)
            }
        }
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

