//
//  TabBarViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/27/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    var tabBarIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.selectedIndex = tabBarIndex

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    
    }

}
