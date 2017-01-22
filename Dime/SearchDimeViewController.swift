//
//  SearchDimeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/17/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "SearchDimeTableViewCell"

class SearchDimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    var user: User?
    var UsersToSearch = [User]()
    var filteredUsers = [User]()
    var selectedUser: User?
    
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    lazy var tableView: UITableView = UITableView()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "icon-back"), middleButtonImage: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(navBar)
        setViewConstraints()
        addSearchProperties()
        
        //searchBar.becomeFirstResponder()
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        
        self.navBar.delegate = self
        self.tableView.register(SearchDimeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        fetchUsers()
        // Do any additional setup after loading the view.
    }
    
    func fetchUsers() {
        self.tableView.reloadData()
        User.observeNewUser { (user) in
            if !self.UsersToSearch.contains(user) {
                self.UsersToSearch.insert(user, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    func setViewConstraints(){
        self.view.addSubview(searchBar)
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        self.searchBar.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
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
        if searchBar.text != ""{
            return self.filteredUsers.count
        }else{
            return self.UsersToSearch.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SearchDimeTableViewCell
        
        cell.setViewConstraints()
        
        var user: User
        
        
        if searchBar.text != ""{
            cell.user = self.filteredUsers[indexPath.row]
        }else{
            cell.user = self.UsersToSearch[indexPath.row]
        }

        cell.backgroundColor = UIColor.white

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.view.bounds.width / 4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
       
        let destinationVC = ProfileCollectionViewController()
        var user: User
        
        if searchBar.text != ""{
            user = self.filteredUsers[indexPath.row]
        }else{
            

            user = self.UsersToSearch[indexPath.row]
        }
        
        destinationVC.user = user
       
        self.navigationController?.pushViewController(destinationVC, animated: true)

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
    

    
}


extension SearchDimeViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
    
}
