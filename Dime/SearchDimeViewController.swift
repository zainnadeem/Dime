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


public enum SearchViewControllerType {
    case friends
    case likes
    case superLikes
    case searchAllUsers
    case showMessages
}

class SearchDimeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    var user: User?
    var dime: Dime?
    
    var UsersToSearch = [User]()
    
    var filteredUsers = [User]()
    var selectedUser: User?
    
    var store = DataStore.sharedInstance
    
    var showingUsersFriends: Bool = Bool()
    
    var findingMessages: Bool = Bool()
    
    lazy var searchBar: UISearchBar = UISearchBar()
    
    lazy var tableView: UITableView = UITableView()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "icon-back"), middleButtonImage: nil)
    

    var viewContollerType: SearchViewControllerType?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(navBar)
        setViewConstraints()
        addSearchProperties()
 
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.searchBar.delegate = self
        
        
        self.navBar.delegate = self
        self.tableView.register(SearchDimeTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    
        configureType()
    }
    
    func configureType(){
        guard let profileUser = self.user else { return }
        
        guard let type = self.viewContollerType else { return }
        
        switch type {
        
        case .friends:
            print("showing friends")
            navBar.middleButton.title = "\(profileUser.username)'s Friends"
            fetchFriends()
            
        case .likes:
            print("likes page")
            navBar.middleButton.title = "Liked By"
            fetchLikers()
            
            
        case .superLikes:
            print("searchAllUsers")
            navBar.middleButton.title = "Super Liked By"
            fetchSuperLikers()
            
        case .searchAllUsers:
            print("searchAllUsers")
            navBar.middleButton.title = "Search Dime"
            fetchAllDimeUsers()

            
        case .showMessages:
            print("show messages page")
            navBar.middleButton.title = "start a conversation"
            fetchFriends()
            
        
        default:
            print("default")
        }
    }
    
    func fetchAllDimeUsers() {
        self.tableView.reloadData()
        User.observeNewUser { (user) in
            if !self.UsersToSearch.contains(user) {
                self.UsersToSearch.insert(user, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchFriends() {
        guard let profileUser = self.user else { return }
        self.UsersToSearch = profileUser.friends
    }
    
    func fetchLikers() {
        guard let currentDime = self.dime else { return }
        self.UsersToSearch = currentDime.likes
    }
    
    func fetchSuperLikers() {
        guard let currentDime = self.dime else { return }
        self.UsersToSearch = currentDime.superLikes
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
        
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -49).isActive = true
        
        
    }
    
    
    func addSearchProperties(){
        self.searchBar.showsSearchResultsButton = true
        self.searchBar.barStyle = .default
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let type = self.viewContollerType else { return 0 }
        
        switch type {
       
        case .friends, .likes, .superLikes:
            if searchBar.text != ""{
                return self.filteredUsers.count
            }else{
                return self.UsersToSearch.count
            }
        
        case .searchAllUsers:
            if searchBar.text != ""{
                return self.filteredUsers.count
            }else{
                return 0
            }
            
        case .showMessages:
            print("showUsers")
        
        default:
            print("default")
        }
        
        return 0
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
       
        
                if self.findingMessages{
                    self.nextDidTap(messageRecipient: user)
            }else{
            
                self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
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

extension SearchDimeViewController {
    
    func nextDidTap(messageRecipient: User){
        
        guard let currentUser = self.user else { return }
        var conversationMembers = [messageRecipient]
        conversationMembers.append(currentUser)
        
        var title = ""
        
        if let chat = findChat(among: conversationMembers){
            openChatView(chat: chat)
        }else{
            
            for acc in conversationMembers{
                if title == "" {
                    title += "\(acc.fullName)"
                }else{
                    title += " + \(acc.fullName)"
                }
            }
            
            
            let newChat = Chat(users: conversationMembers, title: title, featuredImageUID: messageRecipient.uid)
            openChatView(chat: newChat)
            
        }
    }
    
    func findChat(among chatAccounts: [User]) -> Chat?{
        
        //guard let chats = self.store.chats else { return nil }
        
        for chat in self.store.chats{
            
            var results = [Bool]()
            
            for acc in chatAccounts{
                let result = chat.users.contains(acc)
                results.append(result)
            }
            
            if !results.contains(false){
                return chat
            }
        }
        
        return nil
    }
    
    
    func openChatView(chat: Chat){
        guard let currentUser = self.user else { return }
        let chatVC = ChatViewController()
        
        chatVC.senderId = currentUser.uid
        chatVC.senderDisplayName = currentUser.fullName
        
        chatVC.currentUser = store.currentUser
        chatVC.chat = chat
        
        chatVC.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(chatVC, animated: true)
        print("Not sure what the right bar button will do yet.")
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
