//
//  HomeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/14/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class HomeViewController: UIViewController {
    
    var mediaPickerHelper: MediaPickerHelper!
    var currentUser: User?
    var store = DataStore.sharedInstance
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "searchIcon"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    let activityData = ActivityData()
    
    @IBOutlet weak var topDimesButton: UIButton!
    @IBOutlet weak var topFriendsButton: UIButton!
    @IBOutlet weak var trendingButton: UIButton!
    @IBOutlet weak var popularButton: UIButton!
    var homeButtons: [UIButton] = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeButtons = [topDimesButton, topFriendsButton, trendingButton, popularButton]
        makeButtonsBigger()
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    func makeButtonsBigger(){
        for button in homeButtons{
            button.contentEdgeInsets = UIEdgeInsetsMake(-44, -44, -44, -44)
        }
    }
    
    
    @IBAction func popularTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 4
       
    }
    
    @IBAction func trendingTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 3
    }

    @IBAction func friendsTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
    }

    @IBAction func topDimesTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.store.updateFriends()
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.setNavigationBarHidden(true, animated: false)
         self.tabBarController?.navigationController?.setNavigationBarHidden(true, animated: true)
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // get current user
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        
                        self.store.currentDime = nil
                        self.currentUser = User(dictionary: userDict)
                        self.store.currentUser = User(dictionary: userDict)
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        self.store.registerOneSignalToken(user: self.currentUser!)
                        self.store.getCurrentDime()
                        self.store.observeChats({ (chats) in
  
                        })
                       
                    
                        guard let currentUser = self.store.currentUser else { return }
                        
                        
                    
                        currentUser.updatePopularRank()
                        //self.enableButtons()
                    }
                })
                
            }else {
                print("No User")
            }
        })
       
    }
    
//    func enableButtons(){
//        if self.currentUser != nil {
//            self.navBar.rightButton.isEnabled = true
//            self.navBar.leftButton.isEnabled = true
//        }else{
//            self.navBar.rightButton.isEnabled = false
//            self.navBar.leftButton.isEnabled = false
//        }
//    }
    
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
                nextViewController.tabBarIndex = 3
            }
        }else if segue.identifier == "Popular" {
            if let nextViewController = segue.destination as? TabBarViewController{
                nextViewController.tabBarIndex = 4
            }
        }else if segue.identifier == "ShowNotifications"{
            
        }
        
    }



}
extension HomeViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationTableViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {

        
        let destinationVC = SearchDimeViewController()
        destinationVC.user = store.currentUser
        
        if let user = store.currentUser{
            destinationVC.user = user
        }
        
        
        self.navigationController?.pushViewController(destinationVC, animated: true)

        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }



}

extension UIButton {
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var relativeFrame = self.bounds
        var hitTestEdgeInsets = UIEdgeInsetsMake(-22, -22, -22, -22)
        var hitFrame = UIEdgeInsetsInsetRect(relativeFrame, hitTestEdgeInsets)
        return hitFrame.contains(point)
    }
}
