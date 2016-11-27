//
//  AppDelegate.swift
//  Dime
//
//  Created by Zain Nadeem on 11/4/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import CoreData
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        
        if let user = FIRAuth.auth()?.currentUser {

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                //let navVC = initialViewController.parent
                self.window!.rootViewController = initialViewController
            print("User Logged In")
            
            
        }else{
            
            print("No user logged in")
     
        
    }
           return true
    }


}

