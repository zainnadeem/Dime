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
    
    var mediaPickerHelper: MediaPickerHelper!
    var currentUser: User?
    var store = DataStore.sharedInstance
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "searchIcon"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
    }

    @IBAction func topDimesTapped(_ sender: Any) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // get current user
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        self.store.currentDime = nil
                        self.currentUser = User(dictionary: userDict)
                        self.store.currentUser = User(dictionary: userDict)
                        self.store.getCurrentDime()
                        self.store.getImages()
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
        
        if segue.identifier == "TopDimes"{
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 0
            }
        
        } else if segue.identifier == "Dimes" {
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 1
            }
        } else if segue.identifier == "Trending" {
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 2
            }
        }else if segue.identifier == "Popular" {
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 3
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
        if store.currentDime != nil {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
        self.present(controller, animated: true, completion: nil)
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "CreateDimeViewController") as! CreateDimeViewController
            self.present(controller, animated: true, completion: nil)
        }
    
    }
}
