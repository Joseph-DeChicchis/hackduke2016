//
//  SignInTableViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import Firebase

class SignInTableViewController: UITableViewController, UITextFieldDelegate {

    var name = ""
    var emailAddress = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 44.0
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
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameTableViewCell
            
            cell.selectionStyle = .none
            
            cell.nameTextField.tag = 1
            cell.nameTextField.delegate = self
            
            return cell
        }
        
        if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "EmailCell", for: indexPath) as! EmailTableViewCell
            
            cell.selectionStyle = .none
            
            cell.emailTextField.tag = 2
            cell.emailTextField.delegate = self
            
            return cell
        }
        
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasswordCell", for: indexPath) as! PasswordTableViewCell
            
            cell.selectionStyle = .none
            
            cell.passwordTextField.tag = 3
            cell.passwordTextField.delegate = self
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonCell", for: indexPath) as! ButtonsTableViewCell

        cell.selectionStyle = .none
        
        cell.signUpButton.addTarget(self, action: #selector(SignInTableViewController.signup), for: .touchUpInside)
        cell.loginButton.addTarget(self, action: #selector(SignInTableViewController.login), for: .touchUpInside)
        
        return cell
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
                name = updatedTextString as String
                
            case 2:
                emailAddress = updatedTextString as String
                
            case 3:
                password = updatedTextString as String
                
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
            name = textField.text!
            
        case 2:
            emailAddress = textField.text!
            
        case 3:
            password = textField.text!
            
        default:
            NSLog("Text field tag no match")
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        switch textField.tag {
            
        case 1:
            name = ""
            
        case 2:
            emailAddress = ""
            
        case 3:
            password = ""
            
        default:
            NSLog("Text field tag no match")
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField.tag == 1 {
            
            name = textField.text!
            
            let cell = self.tableView.cellForRow(at: IndexPath(item: 1, section: 0)) as! EmailTableViewCell
            
            cell.emailTextField.becomeFirstResponder()
        }
        else if textField.tag == 2 {
            
            emailAddress = textField.text!
            
            let cell = self.tableView.cellForRow(at: IndexPath(item: 2, section: 0)) as! PasswordTableViewCell
            
            cell.passwordTextField.becomeFirstResponder()
        }
        else if textField.tag == 3 {
            
            password = textField.text!
            
            textField.resignFirstResponder()
            
            if name == "" {
                signup()
            }
            else {
                login()
            }
        }
        
        return true
    }
    
    func signup() {
        
        NSLog("SIGNUP || email: \(emailAddress), password: \(password), name: \(name)")
        
        FIRAuth.auth()?.createUser(withEmail: emailAddress, password: password) { (user, error) -> Void in
            
            if let createdUser = user {
                let uid = createdUser.uid
                
                let ref = FIRDatabase.database().reference()
                
                ref.child("users/\(uid)").setValue(["name": self.name])
                
            }
            else {
                
                if error != nil {
                    
                    if error!._code == FIRAuthErrorCode.errorCodeInvalidEmail.rawValue {
                        let alert = UIAlertController(title: "Invalid Emaill Address", message: "The email address you entered is not valid. Please enter a valid email address and try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if error!._code == FIRAuthErrorCode.errorCodeEmailAlreadyInUse.rawValue {
                        let alert = UIAlertController(title: "Email Address Taken", message: "Another account has already been created with the email address you have entered.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if error!._code == FIRAuthErrorCode.errorCodeWeakPassword.rawValue {
                        let alert = UIAlertController(title: "Password too Weak", message: "The password you entered is too weak. Please enter a stronger password and try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if error!._code == FIRAuthErrorCode.errorCodeNetworkError.rawValue || error!._code == FIRAuthErrorCode.errorCodeTooManyRequests.rawValue {
                        let alert = UIAlertController(title: "Network Error", message: "There was a problem communicating with our servers. Please make sure you are connected to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Unknown Error", message: "An unkown error has occured. Please make sure you are connected to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    NSLog("Signup Error: \(error)")
                    
                    self.tableView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func login() {
        
        NSLog("LOGIN || email: \(emailAddress), password: \(password)")
        
        FIRAuth.auth()?.signIn(withEmail: emailAddress, password: password) { (user, error) in
            
            if user == nil {
                // No user is signed in.
                
                if error != nil {
                    
                    if error!._code == FIRAuthErrorCode.errorCodeWrongPassword.rawValue {
                        let alert = UIAlertController(title: "Wrong Password", message: "The password you entered is incorrect. Tap on \"I forgot my password\" below to reset your password if you cannot remember it.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if error!._code == FIRAuthErrorCode.errorCodeNetworkError.rawValue || error!._code == FIRAuthErrorCode.errorCodeTooManyRequests.rawValue {
                        let alert = UIAlertController(title: "Network Error", message: "There was a problem communicating with our servers. Please make sure you are connected to the internet and try again.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if error!._code == FIRAuthErrorCode.errorCodeUserDisabled.rawValue {
                        let alert = UIAlertController(title: "User Account Disabled", message: "Your account has been disabled. We disable accounts when we find that they violate the Community Guidelines. Please contact us to resolve this issue.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    else {
                        let alert = UIAlertController(title: "Check Email Address", message: "Make sure the email address you entered is correct.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
                        
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    NSLog("Login Error: \(error)")
                    
                }
            }
        }
    }

}
