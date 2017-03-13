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
    
    let cellId = "topDimesCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topdimesTableView.delegate = self
        topdimesTableView.dataSource = self
    }
    
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
        let destination = SearchDimeViewController()
        destination.viewContollerType = SearchViewControllerType.searchAllUsers
        present(destination, animated: true, completion: nil)
        
        
        print("Add button tapped!")
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        
//        cell.checkingLayout()
        
        cell.profileImageView.image = store.currentUser?.topFriends[indexPath.row].profileImage
        cell.usernameLabel.text = store.currentUser?.topFriends[indexPath.row].username
    
        
        return cell
    }
}
