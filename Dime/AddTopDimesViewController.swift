//
//  AddTopDimesViewController.swift
//  Dime
//
//  Created by Lloyd W. Sykes on 3/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class AddTopDimeViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    
    @IBOutlet weak var topdimesTableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var user: User?
    
    let cellId = "topDimesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCustomizations()
    }
    
    func viewCustomizations() {
        topdimesTableView.delegate = self
        topdimesTableView.dataSource = self
        
        navigationController?.navigationBar.backgroundColor = .sideMenuGrey()

    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let destination = SearchDimeViewController()
        destination.user = user
        destination.viewContollerType = SearchViewControllerType.searchAllUsers
        present(destination, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func profileImageTapped(_ sender: Any) {
        let destination = ProfileCollectionViewController()
        destination.user = user
        present(destination, animated: true) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            storyboard.instantiateInitialViewController()
        }
    }
    
    @IBAction func topDimeButtonTapped(_ sender: Any) {
        guard
            let user = user,
            let topFriends = store.currentUser?.topFriends else {
                return
        }
        if topFriends.contains(user) {
            store.currentUser?.unTopFriendUser(user: user)
        } else {
            store.currentUser?.topFriendUser(user: user)
        }
        
    }
    
    @IBAction func starRatingButtonTapped(_ sender: Any) {
        profileImageTapped(sender)
    }
    
    @IBAction func messageButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func friendButtonTapped(_ sender: Any) {
        if let user = user {
            store.currentUser?.friendUser(user: user)
        }
    }
}

extension AddTopDimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let topDimesCount = store.currentUser?.topFriends.count else {
            return 1
        }
        return topDimesCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AddDimeTableViewCell
        
        guard
            let topDime = store.currentUser?.topFriends[indexPath.row],
            let topFriends = store.currentUser?.topFriends else {
                return cell
        }
        
        if topFriends.contains(topDime) {
            cell.topDimeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
        } else {
            cell.topDimeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamondUnfilled"), for: .normal)
        }
        
        user = topDime
        
        topDime.downloadProfilePicture { (profilePic, error) in
            if let profilePic = profilePic {
                print("Profile pic successfully downlaoded!")
                cell.profileImageButton.setImage(profilePic.circle, for: .normal)
            } else if let error = error {
                print("There was an error getting the user's profile picture: \(error.localizedDescription)")
                return
            }
        }
        
        cell.usernameLabel.text = topDime.username
        cell.starRatingButton.titleLabel?.text = "\(topDime.popularRank)"
        cell.updateUI()
        
        return cell
    }
}
