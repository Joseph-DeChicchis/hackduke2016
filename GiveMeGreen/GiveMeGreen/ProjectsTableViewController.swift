//
//  ProjectsTableViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import Firebase

class ProjectsTableViewController: UITableViewController {

    var uid = ""
    
    var emailAddress = ""
    
    var userProjects = Array<String>()
    
    var projectArray = Array<Project>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                        
                        self.projectArray.removeAll()
                        
                        for projectID in self.userProjects {
                            self.loadProject(projectID: projectID)
                        }
                        
                    }
                    
                }) { (error) in
                    NSLog(error.localizedDescription)
                }
                
            } else {
                // No user is signed in.
                
                NSLog("not signed in", [])
            }
        }
    }
    
    func loadProject(projectID: String) {
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("projects/\(projectID)").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.exists() {
                
                NSLog("snapshot: \(snapshot)")
                
                let dic = snapshot.value as! NSDictionary
                let temp = Project()
                temp.setup(infoDic: ["name": dic.value(forKey: "Name") as! String, "title": dic.value(forKey: "Title") as! String, "walletAddress": dic.value(forKey: "walletId") as! String, "imageURL": dic.value(forKey: "Picture") as! String, "totalAmount": dic.value(forKey: "Goal") as! Double, "currentAmount": dic.value(forKey: "Donated") as! Double, "bio": dic.value(forKey: "Bio") as! String, "projectID": dic.value(forKey: "projectID") as! String])
                
                self.projectArray.append(temp)
                
                NSLog("rawProjects: \(self.projectArray)")
                
                self.tableView.reloadData()
                
            }
            
        }) { (error) in
            NSLog(error.localizedDescription)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return projectArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = projectArray[indexPath.row].title

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var request = URLRequest(url: URL(string: "https://hackduke2016.herokuapp.com/fundProject?acct_id=\(projectArray[indexPath.row].walletAddress)&email=\(emailAddress)&amount=1")!)
        request.httpMethod = "GET"
        let session = URLSession.shared
        
        session.dataTask(with: request) {data, response, err in
            NSLog("FUND LIKED: \(response)")
            }.resume()
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
