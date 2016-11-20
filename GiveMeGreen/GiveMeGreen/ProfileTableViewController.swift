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

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
