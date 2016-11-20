//
//  ProfileTableViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import Firebase

class ProfileTableViewController: UITableViewController {

    var emailAddress = ""
    
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                
                NSLog("signed in")
                
                self.emailAddress = user!.email!
                
                self.tableView.reloadData()
                
                let ref = FIRDatabase.database().reference()
                
                let uid = user!.uid
                
                ref.child("users/\(uid)/name/").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        self.name = snapshot.value as! String
                        
                        self.tableView.reloadData()
                    }
                    
                }) { (error) in
                    NSLog(error.localizedDescription)
                }
                
            } else {
                // No user is signed in.
                
                NSLog("not signed in", [])
                
                self.emailAddress = ""
                
                self.tableView.reloadData()
            }
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
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        if indexPath.row == 0 {
            cell.textLabel?.text = name
            cell.selectionStyle = .none
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = emailAddress
            cell.selectionStyle = .none
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "Logout"
            cell.selectionStyle = .gray
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            
            do {
                try FIRAuth.auth()!.signOut()
            }
            catch _ {
                NSLog("signout error")
            }
            
        }
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

}
