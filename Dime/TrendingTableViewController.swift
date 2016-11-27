//
//  TrendingTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/27/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

//sorted by most likes


class TrendingTableViewController: UITableViewController {
    
    let store = DataStore.sharedInstance
    var media = [Media]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchMedia()

    }

    @IBAction func homeButtonDidTap(_ sender: Any) {
          self.dismiss(animated: true, completion: nil)
    }
    func fetchMedia() {
        Media.observeNewMedia { (media) in
            if !self.media.contains(media) {
                self.media.insert(media, at: 0)
                self.tableView.reloadData()
            }
        }
    }

 
}

extension TrendingTableViewController {
// MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return media.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if media.count == 0 {
            return 0
        }else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell, for: indexPath) as! MediaHeaderCell
        
        cell.currentUser = store.currentUser
        cell.media = media[indexPath.section]
        cell.selectionStyle = .none
        //cell.delegate = self
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }


    
}
