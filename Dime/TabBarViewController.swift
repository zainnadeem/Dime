//
//  TabBarViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/27/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var tabBarIndex: Int = Int()
    let store = DataStore.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.selectedIndex = tabBarIndex
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // Do any additional setup after loading the view.
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        let navController = self.viewControllers?[selectedIndex] as! UINavigationController
        
        
        guard let currentUser = self.store.currentUser else { return }
       
        for friend in currentUser.friends{
            friend.getMediaCount()
        }
        
   
        
        switch selectedIndex {
        case 0:
            let destinationVC = navController.viewControllers[0] as! TopDimesCollectionViewController
            if destinationVC.dimeCollectionView.numberOfItems(inSection: 0) > 1 {
                destinationVC.dimeCollectionView.reloadData()
                destinationVC.dimeCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
        case 1:
            let destinationVC = navController.viewControllers[0] as! FriendsCollectionViewController
            if destinationVC.dimeCollectionView.numberOfItems(inSection: 0) > 1 {
            destinationVC.dimeCollectionView.reloadData()
            destinationVC.dimeCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
        case 2:
            let destinationVC = navController.viewControllers[0] as! HomeViewController
                

        case 3:
            let destinationVC = navController.viewControllers[0] as! TrendingCollectionViewController
            if destinationVC.dimeCollectionView.numberOfItems(inSection: 0) > 1 {
                destinationVC.dimeCollectionView.reloadData()
                destinationVC.dimeCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
            }
        case 4:
            let destinationVC = navController.viewControllers[0]
                as! PopularFeedTableViewController
            if destinationVC.tableView.numberOfRows(inSection: 0) > 1 {
                destinationVC.tableView.reloadData()
                destinationVC.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
             
            }
        default:
            print("No tab bar selected-- this would be odd to say the least")
        }

        navController.popToRootViewController(animated: false)
    }

    

}
