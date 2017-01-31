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
import DZNEmptyDataSet

private let reuseIdentifier = "NotificationTableViewCell"
private let friendRequestreuseIdentifier = "FriendRequestTableViewCell"

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
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self

        self.tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        self.tableView.register(FriendRequestTableViewCell.self, forCellReuseIdentifier: friendRequestreuseIdentifier)
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
    
    override func viewDidDisappear(_ animated: Bool) {
        self.currentUser.trimNotifications()

        
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

        if self.notifications[indexPath.row].notificationType == NotificationType.friendRequest {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: friendRequestreuseIdentifier, for: indexPath) as! FriendRequestTableViewCell
            
            cell.parentTableView = self.tableView
            cell.parentViewController = self
            cell.currentIndexPath = indexPath
            cell.selectionStyle = .none
            cell.setViewConstraints()
            cell.notification = self.notifications[indexPath.row]
            cell.backgroundColor = UIColor.clear
            
            return cell
        
        }else{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationsTableViewCell
            
            cell.parentViewController = self
            cell.selectionStyle = .none
            cell.setViewConstraints()
            cell.notification = self.notifications[indexPath.row]
            cell.backgroundColor = UIColor.clear

             return cell
        }
        
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
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

extension NotificationTableViewController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = #imageLiteral(resourceName: "friendsHomeUnfilled")
        
        let size = image.size.applying(CGAffineTransform(scaleX: 0.2, y: 0.2))
        let hasAlpha = true
        let scale : CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "Loading your notifications..."
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(24.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        
        
        return NSAttributedString(string: text, attributes: attributes)
        
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text = "wow, there are a lot of them"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(14.0),
                          NSForegroundColorAttributeName : UIColor.lightGray,
                          NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.dimeFontBold(18.0),
                          NSForegroundColorAttributeName : UIColor.black]
        
        return NSAttributedString(string: "Here you go!", attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}


extension NotificationTableViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
