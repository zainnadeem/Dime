//
//  ContactsPickerViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

private let reuseIdentifier = "ContactsTableViewCell"

class ContactsPickerViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    
    var chats: [Chat]!
    var accounts = [User]()
    var currentUser: User!
    
    var selectedAccounts = [User]()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "icon-home"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    lazy var contactsPickerField: VENTokenField = VENTokenField()
    lazy var tableView : UITableView = UITableView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navBar.rightButton.title = "Next"
        
        self.currentUser = self.store.currentUser
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.contactsPickerField.delegate = self
        self.contactsPickerField.dataSource = self
        
        self.navBar.delegate = self
        
        
        self.tableView.register(ContactTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        
        self.view.addSubview(navBar)
        setUpContactsPickerField()
        setUpTableView()
        
        self.fetchUsers()
 
    }

    func fetchUsers(){
        let accountsRef = DatabaseReference.users(uid: currentUser.uid).reference().child("friends")
        accountsRef.observe(.childAdded, with: { (snapshot) in
            let user = User(dictionary: snapshot.value as! [String : Any])
        
            self.accounts.insert(user, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .fade)
        })
    }
    
    func setUpContactsPickerField(){
        self.view.addSubview(contactsPickerField)
        
        
        self.contactsPickerField.translatesAutoresizingMaskIntoConstraints = false
        self.contactsPickerField.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.contactsPickerField.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.contactsPickerField.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.contactsPickerField.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        contactsPickerField.backgroundColor = UIColor.white
        
        contactsPickerField.placeholderText = "Search..."
        contactsPickerField.setColorScheme(UIColor.blue)
        contactsPickerField.delimiters = [",",";","--"]
        contactsPickerField.toLabelTextColor = UIColor.black
    }
    
    
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.contactsPickerField.bottomAnchor, constant: 2.0).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.black
        tableView.tableFooterView = UIView()
    }
    
    // Mark: Helper 
    
    func addRecipient(account: User){
        self.selectedAccounts.append(account)
        self.contactsPickerField.reloadData()
    }
    
    func deleteRecipient(account: User, index: Int){
        self.selectedAccounts.remove(at: index)
        self.contactsPickerField.reloadData()
        
    }
    
   // MARK: - CHAT 
    
    func nextDidTap(){
        var chatAccounts = selectedAccounts
        chatAccounts.append(currentUser)
        var title = ""
        if let chat = findChat(among: chatAccounts){
            openChatView(chat: chat)
        }else{
            
            for acc in chatAccounts{
                if title == "" {
                    title += "\(acc.fullName)"
                }else{
                    title += "+ \(acc.fullName)"
                }
            }
        }
        let newChat = Chat(users: chatAccounts, title: title, featuredImageUID: chatAccounts.first!.uid)
        openChatView(chat: newChat)
    }
    
    func findChat(among chatAccounts: [User]) -> Chat?{
        if chats == nil {return nil}
        
        for chat in chats{
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

// MARK: - VENTokenFieldDataSource

extension ContactsPickerViewController : VENTokenFieldDataSource{
    
    func tokenField(_ tokenField: VENTokenField, titleForTokenAt index: UInt) -> String {
        return selectedAccounts[Int(index)].fullName
    }
    
    func numberOfTokens(in tokenField: VENTokenField) -> UInt {
        return UInt(selectedAccounts.count)
    }
}

// MARK: - VENTokenFieldDelegate

extension ContactsPickerViewController : VENTokenFieldDelegate {
    func tokenField(_ tokenField: VENTokenField, didEnterText text: String) {
        
    }
    
    func tokenField(_ tokenField: VENTokenField, didDeleteTokenAt index: UInt) {
        let indexPath = IndexPath(row: Int(index), section: 0)
        let cell = self.tableView.cellForRow(at: indexPath) as!
        ContactTableViewCell
        cell.added = !cell.added
        self.deleteRecipient(account: cell.user, index: Int(index))
        
    }
}

// MARK: - TableViewDelegate




// MARK: - Table view data source
extension ContactsPickerViewController : UITableViewDelegate, UITableViewDataSource{

    
func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return self.accounts.count
}


func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ContactTableViewCell

    let user = accounts[indexPath.row]
    cell.setViewConstraints()
    cell.user = user
    cell.selectionStyle = .none
    return cell
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return  self.view.bounds.width / 4
}


func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
 let cell = tableView.cellForRow(at: indexPath) as! ContactTableViewCell
    cell.added = !cell.added
    
    if cell.added == true {
        self.addRecipient(account: cell.user)
    }else{
        let index = selectedAccounts.index(of: cell.user)!
        self.deleteRecipient(account: cell.user, index: index)
    }

}

}


extension ContactsPickerViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        nextDidTap()
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}
