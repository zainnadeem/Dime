//
//  MediaTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class MediaTableViewController: UITableViewController {
    
    let store = DataStore.sharedInstance
    var passedIndex: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
            
            cell.setCellProperties()
            
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "mediaCell", for: indexPath) as! MediaTableViewCell
            cell.setCellProperties(withDimeMedia: (store.currentDime?.media[passedIndex])!)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0 {
            return 60.0
        }else{
            return 598.0
        }
    }
}



