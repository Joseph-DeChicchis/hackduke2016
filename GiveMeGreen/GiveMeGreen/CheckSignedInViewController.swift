//
//  CheckSignedInViewController.swift
//  GiveMeGreen
//
//  Created by Joseph DeChicchis on 11/20/16.
//  Copyright © 2016 HackDuke 2016 Project. All rights reserved.
//

import UIKit

import Firebase

class CheckSignedInViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NSLog("CheckSignedInViewController")
        
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            
            if user != nil {
                // User is signed in.
                NSLog("signed in")
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SignedInWindow") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = viewController
                
            } else {
                // No user is signed in.
                NSLog("not signed in", [])
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewController(withIdentifier: "SignInWindow") as! UINavigationController
                UIApplication.shared.keyWindow?.rootViewController = viewController
            }
        }

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
