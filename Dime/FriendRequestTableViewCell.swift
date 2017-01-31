//
//  FriendRequestTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 1/19/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import NSDate_TimeAgo
import SAMCache
import OneSignal

class FriendRequestTableViewCell: UITableViewCell {
    
    lazy var profileImage           : UIButton      = UIButton()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var fullName               : UILabel       = UILabel()
    lazy var notificationLabel      : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    
    lazy var ignoreFriendButton           : UIButton      = UIButton()
    lazy var confirmFriendButton          : UIButton      = UIButton()
    
    weak var parentTableView = UITableView()
    weak var parentViewController = UIViewController()
    var currentIndexPath = IndexPath()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    lazy var mediaImageHeightMultiplier   : CGFloat =      (0.45)
    lazy var mediaImageWidthMultiplier   : CGFloat =       (0.12)
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    
    var notification: Notification! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func setViewConstraints() {
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.confirmFriendButton.translatesAutoresizingMaskIntoConstraints = false
        self.ignoreFriendButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.profileImage)
        self.profileImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.profileImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.profileImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.ignoreFriendButton)
        self.ignoreFriendButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.ignoreFriendButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -11.5).isActive = true
        self.ignoreFriendButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: mediaImageHeightMultiplier).isActive = true
        self.ignoreFriendButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: mediaImageWidthMultiplier).isActive = true
        
        self.contentView.addSubview(self.confirmFriendButton)
        self.confirmFriendButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.confirmFriendButton.trailingAnchor.constraint(equalTo: self.ignoreFriendButton.leadingAnchor, constant: -7.5).isActive = true
        
        self.confirmFriendButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: mediaImageHeightMultiplier).isActive = true
        self.confirmFriendButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: mediaImageWidthMultiplier).isActive = true
        
        
        
        ignoreFriendButton.addTarget(self, action: #selector(ignoreFriendButtonTapped), for: .touchUpInside)
        confirmFriendButton.addTarget(self, action: #selector(confirmFriendButtonTapped), for: .touchUpInside)
        
        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.confirmFriendButton.leadingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.45).isActive = true
        //self.mainLabelStackview.addArrangedSubview(self.fullName)
        self.mainLabelStackview.addArrangedSubview(self.notificationLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    
    func ignoreFriendButtonTapped(){

        guard let currentUser = self.store.currentUser else { return }
        currentUser.unFriendUser(user: self.notification.from)
        self.notification.from.unFriendUser(user: currentUser)
        
        ignoreFriendButton.setImage(#imageLiteral(resourceName: "RedFriendIgnorePressed"), for: .normal)
        confirmFriendButton.setImage(#imageLiteral(resourceName: "FriendsHomeGrayedOut"), for: .normal)
        print("Ignored Friend request")
        
        
        self.deleteRow()
        
    }
    
    func confirmFriendButtonTapped(){
        
        guard let currentUser = self.store.currentUser else { return }
        currentUser.friendUser(user: self.notification.from)
        self.notification.from.friendUser(user: currentUser)
        
        ignoreFriendButton.setImage(#imageLiteral(resourceName: "redFriendIgnore"), for: .normal)
        confirmFriendButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
        
        for id in self.notification.from.deviceTokens{
            OneSignal.postNotification(["contents" : ["en" : "\(currentUser.username) accepted your friend request!"], "subtitle" : ["en" : "New Friend!"], "include_player_ids" : [id]])
        }
        
    
        self.deleteRow()
        
    }
    
    func deleteRow(){
        
        
        let parentView = self.parentViewController as! NotificationTableViewController
        parentView.notifications.remove(at: currentIndexPath.row)
        self.parentTableView?.deleteRows(at: [currentIndexPath], with: .fade)
        
        UIView.performWithoutAnimation({
            let loc = parentTableView?.contentOffset
            if parentTableView?.visibleCells.count == 0{
                print("one cell")
            }else{
            parentTableView?.reloadRows(at: [currentIndexPath], with: .none)
            
            parentTableView?.contentOffset = loc!
            }
            })
        
        self.store.currentUser?.deleteNotification(notification: notification)
        self.parentTableView?.reloadData()
    
    
    }
    

    
    
    func updateUI()
    {
        
        profileImage.setImage(UIImage(named: "icon-defaultAvatar"), for: .normal)
        
        let profileImageKey = "\(self.notification.from.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage
        {
            self.profileImage.setImage(image, for: .normal)
            
        }else{
            notification.from.downloadProfilePicture { [weak self] (image, error) in
                self?.profileImage.setImage(image, for: .normal)
                self?.cache?.setObject(image, forKey: profileImageKey)
            }
        }
        
        self.confirmFriendButton.setImage(#imageLiteral(resourceName: "FriendsHomeGrayedOut"), for: .normal)
        self.ignoreFriendButton.setImage(#imageLiteral(resourceName: "redFriendIgnore"), for: .normal)
        
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.masksToBounds = true
        setImageViewCircular()
        fullName.text = notification.from.username
        fullName.textColor = UIColor.darkGray
        fullName.font = UIFont.dimeFontBold(12)
        
        notificationLabel.text = notification.caption
        notificationLabel.textColor = UIColor.black
        notificationLabel.font = UIFont.dimeFontBold(12)
        notificationLabel.numberOfLines = 10
        
        timeAgoLabel.text = parseDate(notification.createdTime)
        //parseDate(business.latestVideo["dateCreated"] as! String)
        //timeAgoLabel.text = parse   comment.createdTime.description
        timeAgoLabel.textColor = UIColor.black
        timeAgoLabel.font = UIFont.dimeFont(10)
    }
    

    
    func ProfileImageButtonTapped(){
        print("Segue to user")
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = notification.from
        self.parentViewController?.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func setImageViewCircular() {
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.isUserInteractionEnabled = true
        self.profileImage.layer.cornerRadius = self.frame.height * profileImageHeightMultiplier / 2
        self.profileImage.layer.borderColor = UIColor.black.cgColor
        self.profileImage.layer.borderWidth = borderWidth
        self.profileImage.clipsToBounds = true
    }
    
    
}

fileprivate func parseDate(_ date : String) -> String {
    
    if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
        return timeAgo
    }
    else { return "" }
}
