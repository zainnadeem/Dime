//
//  WelcomeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    var store = DataStore.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()


    }
   
    override func viewDidAppear(_ animated: Bool) {
        
        if let user = FIRAuth.auth()?.currentUser {
            self.performSegue(withIdentifier: Storyboard.showHomeSegue, sender: nil)
            print("User Logged In")
            
        }else{
            
            print("No user logged in")
            
            
        }

    }
    
    
        override var prefersStatusBarHidden: Bool {
        return false
    }
}
