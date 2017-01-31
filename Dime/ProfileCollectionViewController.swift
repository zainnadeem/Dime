//
//  DimeCollectionViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import SAMCache
import OneSignal

private let reuseIdentifier = "dimeCollectionViewCell"

class ProfileCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    

    var user : User?
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerIcon: UIButton = UIButton()
    var viewAllMessagesButton: UIButton = UIButton()
    var friendDiamond: UIButton = UIButton()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage:nil, leftButtonImage: #imageLiteral(resourceName: "backArrow"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    
    var dimeCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
        self.dimeCollectionView.emptyDataSetDelegate = self
        self.dimeCollectionView.emptyDataSetSource = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_White")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        configureTitleLabel()
        configureTitleIcon()
        

        
        configureUserSpecificButtons()
        
        fetchDimes()
        
        if self.passedDimes.isEmpty{
        self.configureMessagesIcon()
        self.configureFriendDiamond()
        }
        
        
        
    }
    
    func configureUserSpecificButtons(){
        
        guard let profileUser = self.user else { return }
        
        if profileUser == self.store.currentUser {
          
          navBar.rightButton.image = #imageLiteral(resourceName: "icon-settings-filled")
          navBar.rightButton.isEnabled = true
         
         self.viewAllMessagesButton.removeTarget(self, action: #selector(startChat), for: .touchUpInside)
         self.viewAllMessagesButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)
    
        
            
        }else{
            
            navBar.rightButton.image = nil
            navBar.rightButton.isEnabled = false
            
            self.viewAllMessagesButton.removeTarget(self, action: #selector(showChats), for: .touchUpInside)
            self.viewAllMessagesButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDimes()
        
        if self.passedDimes.isEmpty{
            self.configureMessagesIcon()
            self.configureFriendDiamond()
        }
    }
    
    func configureTitleLabel(){
        self.view.addSubview(viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.viewControllerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        viewControllerTitle.backgroundColor = UIColor.dimeDarkBlue()
        viewControllerTitle.textAlignment = NSTextAlignment.left
        viewControllerTitle.textColor = UIColor.white
        viewControllerTitle.font = UIFont.dimeFontBold(15)
        if let currentUser = self.user{
        viewControllerTitle.text = "\(currentUser.username)'s Profile"
        viewControllerTitle.textAlignment = .center
        }
    }
    
    func configureTitleIcon() {
        self.view.addSubview(viewControllerIcon)
        //viewControllerIcon.setImage(<#T##image: UIImage?##UIImage?#>, for: <#T##UIControlState#>)
        
        
        self.viewControllerIcon.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.viewControllerIcon.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewControllerIcon.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewControllerIcon.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureMessagesIcon() {
        self.view.addSubview(viewAllMessagesButton)
        viewAllMessagesButton.setImage(#imageLiteral(resourceName: "icon-chatWhite"), for: .normal)
        viewAllMessagesButton.imageView?.tintColor = UIColor.white
        
        self.viewAllMessagesButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewAllMessagesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        self.viewAllMessagesButton.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewAllMessagesButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewAllMessagesButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureFriendDiamond() {
        self.view.addSubview(friendDiamond)
        
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        if currentUser.topFriends.contains(profileUser){
            self.friendDiamond.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
        }else if currentUser.friends.contains(profileUser){
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blueDiamond"), for: .normal)
        }else{
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blueDiamondUnfilled"), for: .normal)
        }

        friendDiamond.titleLabel?.font = UIFont.dimeFont(16)
        friendDiamond.setTitleColor(UIColor.black, for: .normal)
        friendDiamond.tintColor = UIColor.black
        friendDiamond.addTarget(self, action: #selector(filterFriendAlert), for: .touchUpInside)
        

        self.friendDiamond.translatesAutoresizingMaskIntoConstraints = false
        self.friendDiamond.trailingAnchor.constraint(equalTo: self.viewAllMessagesButton.leadingAnchor, constant: -10).isActive = true
        self.friendDiamond.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.friendDiamond.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.friendDiamond.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }

    
    
    
    func fetchDimes() {
        self.dimeCollectionView.reloadData()
        Dime.observeNewDimeForUser(user: user!, { (dime) in            
            
            if !self.passedDimes.contains(dime) {
                self.passedDimes.insert(dime, at: 0)
                
                self.friendDiamond.isHidden = true
                self.friendDiamond.isEnabled = false
                
                self.dimeCollectionView.reloadData()
                
            }
        })
    }
    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return passedDimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DimeCollectionViewCell
        
        cell.parentCollectionView = self
        cell.collectionView = dimeCollectionView
        
        cell.currentUser = store.currentUser
        cell.dime = passedDimes[indexPath.row]
        
        cell.usernameButton.isUserInteractionEnabled = false
        cell.circleProfileView.isUserInteractionEnabled = false
        
        return cell
    }
    
    
    
    func setUpCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        dimeCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        
        
        
        dimeCollectionView.dataSource = self
        dimeCollectionView.delegate = self
        self.dimeCollectionView.register(DimeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        dimeCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(dimeCollectionView)
     
        dimeCollectionView.isPagingEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let collectionViewWidth = self.view.bounds.size.width
        let collectionViewHeight = self.view.bounds.size.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
   
    
    func showChats(){
        let destinationVC = ChatsTableViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
    
}

extension ProfileCollectionViewController {
    
    func startChat(){
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        var conversationMembers = [profileUser]
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
            
            
            let newChat = Chat(users: conversationMembers, title: title, featuredImageUID: profileUser.uid)
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
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
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

extension ProfileCollectionViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        let destinationVC = SettingsViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        guard let profileUser = user else { return }
        
        if profileUser != store.currentUser {
            let destinationVC = ProfileCollectionViewController()
            destinationVC.user = store.currentUser
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
    }
    
}

extension ProfileCollectionViewController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = #imageLiteral(resourceName: "topDimesHomeUnfilled")
        
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
        let text = "No Dimes😪"
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(24.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        
        
        return NSAttributedString(string: text, attributes: attributes)
        
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(14.0),
                          NSForegroundColorAttributeName : UIColor.lightGray,
                          NSParagraphStyleAttributeName : paragraph]
        
        
        guard let profileUser = self.user else { return NSAttributedString(string: "No photos or videos", attributes: attributes) }
        
        var text = "\(profileUser.username) has not added any photos or videos."
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.dimeFontBold(18.0),
                          NSForegroundColorAttributeName : UIColor.black]
        
        return NSAttributedString(string: "Check back later!", attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}


extension ProfileCollectionViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}


//ConfigureFriendButton
extension ProfileCollectionViewController {

    func filterFriendAlert(){
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        let actionSheet = UIAlertController(title: "\(profileUser.username)", message: "", preferredStyle: .actionSheet)
        
        let topFriends = UIAlertAction(title: "Top Dimes", style: .default, handler: {
            action in
            
            
            currentUser.topFriendUser(user: profileUser)
            currentUser.friendUser(user: profileUser)
            profileUser.getMediaCount()
            self.configureFriendDiamond()
            
            
        })
        
        let friend = UIAlertAction(title: "Send Friend Request", style: .default, handler: {
            action in
            
            
            let notification = Notification(dimeUID: "", mediaUID: "", toUser: profileUser.uid, from: currentUser, caption: "\(currentUser.username) wants to be your friend!", notificationType: .friendRequest)
            
            notification.save()

            for id in profileUser.deviceTokens{
                OneSignal.postNotification(["contents" : ["en" : "\(currentUser.username) wants to be your friend!"], "headings" : ["en" : "Friend Request"], "include_player_ids" : [id]])
            }
            
            
        })
        
        
        let unfriend = UIAlertAction(title: "Unfriend", style: .default, handler: {
            action in
            
            currentUser.unTopFriendUser(user: profileUser)
            currentUser.unFriendUser(user: profileUser)
            
            profileUser.unFriendUser(user: currentUser)
            profileUser.unTopFriendUser(user: currentUser)
            
            self.configureFriendDiamond()
            
            
        })
        
        
        let removeFromTopFriends = UIAlertAction(title: "remove from top dimes", style: .default, handler: {
            action in
            currentUser.unTopFriendUser(user: profileUser)
            self.configureFriendDiamond()
            
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("Canceled")
        })
        
        
        
        if !currentUser.friends.contains(profileUser) {
            actionSheet.addAction(friend)
        }
        
        if currentUser.topFriends.contains(profileUser){
            actionSheet.addAction(removeFromTopFriends)
            actionSheet.addAction(unfriend)
        }
        
        if currentUser.friends.contains(profileUser) && !currentUser.topFriends.contains(profileUser) {
            actionSheet.addAction(topFriends)
            actionSheet.addAction(unfriend)
        }
        
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}
