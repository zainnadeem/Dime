//
//  SearchUserTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/1/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class SearchUserViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    weak var taggingViewController : TaggingViewController?
    
    var userForView: User?
    var UsersToSearch = [User]()
    var filteredUsers = [User]()
    var selectedUser: User?
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        searchBar.becomeFirstResponder()
        if let friends = userForView?.friends {
            UsersToSearch = friends
    }

    
        
}

    // Mark - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchBar.text != ""{
            return self.filteredUsers.count
        }else{
            return self.UsersToSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchUserCell, for: indexPath) as! SearchUserTableViewCell
        
        var user: User
        
        if searchBar.text != ""{
            user = self.filteredUsers[indexPath.row]
        }else{
            user = self.UsersToSearch[indexPath.row]
        }
       
        cell.updateUI(user: user)
        
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var user: User
        
        if searchBar.text != ""{
            user = self.filteredUsers[indexPath.row]
        }else{
            user = self.UsersToSearch[indexPath.row]
        }
        
        taggingViewController?.media?.usersTagged.append(user)
        taggingViewController?.tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark: Search 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredUsers = self.UsersToSearch.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        
            tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        taggingViewController?.hideButtons()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        taggingViewController?.unhideButtons()
    }
    
}
