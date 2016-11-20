//
//  NewProjectTableViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import Firebase

class NewProjectTableViewController: UITableViewController, UITextFieldDelegate {

    var titleString = ""
    var bio = ""
    var goalAmount = 0.0
    
    var name = ""
    var emailAddress = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                // User is signed in.
                
                NSLog("signed in")
                
                self.emailAddress = user!.email!
                
                let ref = FIRDatabase.database().reference()
                
                let uid = user!.uid
                
                ref.child("users/\(uid)/name/").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if snapshot.exists() {
                        
                        self.name = snapshot.value as! String
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
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as! TitleTableViewCell
            
            cell.titleTextField.tag = 1
            cell.titleTextField.delegate = self
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BioCell", for: indexPath) as! BioTableViewCell
            
            cell.bioTextField.tag = 2
            cell.bioTextField.delegate = self
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalAmountCell", for: indexPath) as! GoalAmountTableViewCell

        cell.goalAmountTextField.tag = 3
        cell.goalAmountTextField.delegate = self
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    @IBAction func back(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // MARK: - Text field
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text {
            var updatedTextString: NSString = text as NSString
            updatedTextString = updatedTextString.replacingCharacters(in: range, with: string) as NSString
            
            switch textField.tag {
                
            case 1:
                titleString = updatedTextString as String
                
            case 2:
                bio = updatedTextString as String
                
            case 3:
                goalAmount = Double(updatedTextString as String)!
                
            default:
                NSLog("Text field tag no match")
            }
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        switch textField.tag {
            
        case 1:
            titleString = textField.text!
            
        case 2:
            bio = textField.text!
            
        case 3:
            goalAmount = Double(textField.text!)!
            
        default:
            NSLog("Text field tag no match")
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField.tag {
            
        case 1:
            titleString = ""
            
        case 2:
            bio = ""
            
        case 3:
            goalAmount = 0.0
            
        default:
            NSLog("Text field tag no match")
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            titleString = textField.text!
            
            let cell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! EmailTableViewCell
            
            cell.emailTextField.becomeFirstResponder()
            
        }
        else if textField.tag == 2 {
            
            bio = textField.text!
            
            let cell = self.tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! PasswordTableViewCell
            
            cell.passwordTextField.becomeFirstResponder()
        }
        else if textField.tag == 3 {
            
            goalAmount = Double(textField.text!)!
            
            textField.resignFirstResponder()
            
            post(self)
        }
        
        return true
    }

    @IBAction func post(_ sender: Any) {
        let ref = FIRDatabase.database().reference()
        
        let key = ref.child("projects").childByAutoId().key
        /*
         let activity = ["uid": uid,
         "description": descriptionText,
         "location": locationText,
         "timePosted": timeStamp,
         "interest": selectedInterest,
         "activityTime": activityTime,
         "numberGoing": 1,
         "key": key,
         "locationSaved": false,
         "sent": false] as [String : Any]*/
        
        let project = ["Name": name,
                       "Email": emailAddress,
                       "ID":100,
                       "Title": titleString,
                       "Picture":"gs://give-me-green.appspot.com/generic.jpg",
                       "Bio": bio,
                       "Donated": 0.0,
                       "Goal": goalAmount,
                       "Start":1478790022,
                       "End":1480086022,
                       "walletId":"a5de2e57-85e7-5ddb-8a35-47fd6b6628d3",
                       "walletName":"test-new",
                       "projectID": key] as [String : Any]
        
        NSLog("KEYKEY: \(key)")
        
        ref.child("projects/\(key)").setValue(project)
    }
    

}
