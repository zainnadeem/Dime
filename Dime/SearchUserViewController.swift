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
    
    
    var userForView: User?
    var UsersToSearch = [User]()
    var filteredUsers = [User]()
    
    
    @IBOutlet weak var searchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let usersFollowed = userForView?.follows {
            UsersToSearch = usersFollowed
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
        
        print(user.username)
    }
    
    //Mark: Search 
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredUsers = self.UsersToSearch.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
        
            tableView.reloadData()
    }
    
    
    
    
//    func filteredContentForSearchText(searchText: String, scope: String = "title"){
//        self.filteredUsers = self.UsersToSearch.filter({ (user: User) -> Bool in
//            var categoryMatch = (scope == "title")
//            var stringMatch = user.fullName.range(of: searchText)
//            return categoryMatch && (stringMatch != nil)
//  
//        })
//    }
//    
//    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearch searchString: String?) -> Bool {
//        self.filteredContentForSearchText(searchText: searchString!, scope: "title")
//        
//        return true
//    }
//    
//    func searchDisplayController(_ controller: UISearchDisplayController, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
//        self.filteredContentForSearchText(searchText: (self.searchDisplayController?.searchBar.text)!, scope: "title")
//        
//        return true
//    }


}
