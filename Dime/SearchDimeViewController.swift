//
//  SearchDimeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/17/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentTableViewCell"

class SearchDimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    var user: User?
    var UsersToSearch = [User]()
    var filteredUsers = [User]()
    var selectedUser: User?
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    lazy var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setViewConstraints()
        addSearchProperties()
        
        searchBar.becomeFirstResponder()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        
        self.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        // Do any additional setup after loading the view.
    }
    
    func setViewConstraints(){
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBar.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.searchBar.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        self.tableView.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor).isActive = true
        self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        
    }
    
    func addSearchProperties(){
        self.searchBar.showsSearchResultsButton = true
        self.searchBar.barStyle = .default
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if searchBar.text != ""{
//            return self.filteredUsers.count
//        }else{
            return self.UsersToSearch.count
//        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchUserCell, for: indexPath) as! SearchUserTableViewCell
        
        var user: User
        
//        if searchBar.text != ""{
//            user = self.filteredUsers[indexPath.row]
//        }else{
            user = self.UsersToSearch[indexPath.row]
//        }
        
        cell.updateUI(user: user)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        var user: User
//        
//        if searchBar.text != ""{
//            user = self.filteredUsers[indexPath.row]
//        }else{
//            user = self.UsersToSearch[indexPath.row]
//        }
//        
//
//        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark: Search
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        FIRDatabase.database().reference().child("users").queryOrdered(byChild: "username").queryStarting(atValue: searchBar.text!).queryEnding(atValue: searchBar.text).observeSingleEvent(of: .childAdded, with: { (snapshot) in
            
            print(snapshot.value as! [String : Any])
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filteredUsers = self.UsersToSearch.filter { $0.fullName.localizedCaseInsensitiveContains(searchText) }
//        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
