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
import GooglePlaces
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FIRApp.configure()
        GMSPlacesClient.provideAPIKey("AIzaSyB7hGvbTz2rMiS3E5Dpb8W03CkyCCB-ARE")
    
        if let user = FIRAuth.auth()?.currentUser {
    
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                 var rootViewController = self.window!.rootViewController as! UINavigationController
                 rootViewController.pushViewController(initialViewController, animated: true)
            
            print("User Logged In")
            
            
        }else{
            
            print("No user logged in")
     
        
    }
         IQKeyboardManager.sharedManager().enable = true
           return true
    }


}

