//
//  HomeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/14/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User?
    var store = DataStore.sharedInstance
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // get current user
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        self.currentUser = User(dictionary: userDict)
                        self.store.currentUser = User(dictionary: userDict)
                    }
                })
                
            }else {
                self.performSegue(withIdentifier: Storyboard.showWelcome, sender: nil)
            }
        })
       
    }
    
    
    @IBAction func photoButtonDidTap(_ sender: Any) {
      

    }
    

    @IBAction func logOutDidTap() {
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "trending"{
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 3
            }
        } else if segue.identifier == "Friends" {
                if let nextViewController = segue.destination as? TabBarViewController{
                    nextViewController.tabBarIndex = 1
            }

        }
    }
}

extension HomeViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}
