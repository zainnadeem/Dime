//
//  ChatsTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 1/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import VENTokenField

private let reuseIdentifier = "ChatTableViewCell"

class ChatsTableViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    
    var chats = [Chat]()
    var accounts = [User]()
    var currentUser: User!
    
    var selectedAccounts = [User]()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "backArrow"), middleButtonImage: nil)
    lazy var contactsPickerField: VENTokenField = VENTokenField()
    lazy var tableView : UITableView = UITableView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = self.store.currentUser
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navBar.delegate = self
        
        self.observeChats()
        self.tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(navBar)
        setUpTableView()
        
        
        
    }
    
    func observeChats() {
        let userChatIdsRef = DatabaseReference.users(uid: currentUser.uid).reference().child("chatIds")
        
        userChatIdsRef.observe(.childAdded) { (snapshot: FIRDataSnapshot) in
            let chatId = snapshot.key
            
            // go download that chat
            DatabaseReference.chats.reference().child(chatId).observeSingleEvent(of: .value, with: { (snapshot: FIRDataSnapshot) in
                let chat = Chat(dictionary: snapshot.value as! [String : Any])
                if !self.alreadyAdded(chat) {
                    self.chats.append(chat)
                    let indexPath = IndexPath(row: self.chats.count - 1, section: 0)
                    self.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
    
    
    func alreadyAdded(_ chat: Chat) -> Bool {
        for c in chats {
            if c.uid == chat.uid {
                return true
            }
        }
        
        return false
    }
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 0.8).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.black
        tableView.tableFooterView = UIView()
    }
}

extension ChatsTableViewController : UITableViewDelegate, UITableViewDataSource{
        
        
        func numberOfSections(in tableView: UITableView) -> Int {
            // #warning Incomplete implementation, return the number of sections
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            // #warning Incomplete implementation, return the number of rows
            return chats.count
        }
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ChatTableViewCell
            
            let chat = chats[indexPath.row]
            cell.setViewConstraints()
            cell.chat = chat
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return  self.view.bounds.width / 4
        }
        
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let chatVC = ChatViewController()
            chatVC.senderId = currentUser.uid
            chatVC.senderDisplayName = currentUser.fullName
            
            chatVC.currentUser = store.currentUser
            chatVC.chat = chats[indexPath.row]
            
            chatVC.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(chatVC, animated: true)
            print("Not sure what the right bar button will do yet.")
            
        }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Messages"
    }
        
    }
    
    
    extension ChatsTableViewController : NavBarViewDelegate {
        
        func rightBarButtonTapped(_ sender: AnyObject) {
//            let destinationVC = ContactsPickerViewController()
//            destinationVC.currentUser = store.currentUser
//            self.navigationController?.pushViewController(destinationVC, animated: true)
            print("Not sure what the right bar button will do yet.")
        }
        
        func leftBarButtonTapped(_ sender: AnyObject) {
            
           self.navigationController?.popViewController(animated: true)
            print("Not sure what the left bar button will do yet.")
        }
        
        func middleBarButtonTapped(_ Sender: AnyObject) {
          
        }
        
    }

