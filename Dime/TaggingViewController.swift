//
//  TaggingViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/2/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class TaggingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    var passedMedia: Media?
    var media: Media?
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        media = passedMedia
        media?.mediaImage = mediaImageView.image
    }

    
    @IBAction func imageTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ShowSearchUserController", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearchUserController"{
            
            let destinationVC = segue.destination as! SearchUserViewController
            destinationVC.taggingViewController = self
            if let user = store.currentUser{
                destinationVC.userForView = user }
        }
    }


//Mark: - UITableView
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = media?.usersTagged.count {
                return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchUserCell, for: indexPath) as! SearchUserTableViewCell
        
        if let users = media?.usersTagged {
        cell.updateUI(user: users[indexPath.row])
        }
       
        return cell
    }
    
        
}
