//
//  NotificationsTableViewController.swift
//
//  Dime
//
//  Created by Zain Nadeem on 12/1/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "NotificationTableViewCell"

class NotificationTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    
    let store = DataStore.sharedInstance
    var dime: Dime!
    var media: Media!
    var currentUser: User!
    var notifications = [Notification]()
    
    var captionTextView: UITextField = UITextField()
    var postButton: UIButton = UIButton()
    
    
    lazy var tableView : UITableView = UITableView()
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "icon-back"), middleButtonImage: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        currentUser = self.store.currentUser
        fetchNotifications()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        
        setUpTableView()

        self.tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }


    func fetchNotifications() {
        self.tableView.reloadData()
        self.currentUser.observeNewNotification { (notification) in
            if !self.notifications.contains(notification) {
                self.notifications.insert(notification, at: 0)
                self.notifications = sortByMostRecentlyCreated(self.notifications)
                self.tableView.reloadData()
            }
        }
    }

    // Mark - UITableView
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.notifications.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsTableViewCell
        cell.parentTableView = self
        cell.selectionStyle = .none
        cell.setViewConstraints()
        cell.notification = self.notifications[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.view.bounds.width / 4
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // "Shows user profile"
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "NOTIFICATIONS"
    }
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        self.tableView.backgroundColor = UIColor.white
        self.tableView.separatorColor = UIColor.black
        tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.alpha = 0.85
    }
    
    

    
}


extension NotificationTableViewController : NavBarViewDelegate {
    
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
