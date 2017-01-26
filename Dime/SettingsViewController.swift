//
//  SettingsViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/16/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import QuickTableViewController
import Firebase

class SettingsViewController: QuickTableViewController {
    
    var user : User?
    let store = DataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon-back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backButton
        
        tableContents = [
            Section(title: "Privacy", rows: [
                
                SwitchRow(title: "Private Account", switchValue: true, action: { _ in }),
                NavigationRow(title: "Terms", subtitle: .none)
                ]),
            
                Section(title: "Feedback", rows: [
                TapActionRow(title: "Submit", action: openMailForFeedback)
                
                ]),
            
                Section(title: "", rows: [
                TapActionRow(title: "Log Out", action: logOutUser)
                
                ])
        ]
   
        
    }
    
    
    func back(_ sender: UIBarButtonItem){
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
    
    
    private func  openMailForFeedback(_ sender: Row){
        let email = "dimeAppDevelopment@gmail.com"
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.shared.open(url as! URL, options: [:], completionHandler: nil)
    }

    private func logOutUser(_ sender: Row){
        
        let alertVC = UIAlertController(title: "Are you sure you want to log out?", message: "", preferredStyle: .alert)
        let logOut = UIAlertAction(title: "Log Out", style: .default, handler: {
            action in
            
            print("Logout tapped")
            
            do {
                
                try FIRAuth.auth()?.signOut()
                self.store.currentUser?.unregisterToken()
            
            }catch{
                print("error \(error)")
            }
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let loginVC = storyboard.instantiateViewController(withIdentifier: "initialLogin")
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let transition = CATransition()
            transition.type = kCATransitionFade
            appDelegate.window!.setRootViewController(loginVC, transition: transition)


            
            
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            
        })
        
        alertVC.addAction(logOut)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true, completion: nil)
    }
        

}


