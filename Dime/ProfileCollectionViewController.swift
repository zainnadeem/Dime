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
import Firebase

private let reuseIdentifier = "ProfileCollectionViewCell"

class ProfileCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    
    
    var user : User?
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    
    
    
    //for header view
    var banner: UIView = UIView()
    var userNameButton: UIButton = UIButton()
    var friendDiamond: UIButton = UIButton()
    var circleProfileView = UIButton()
    var messagesButton: UIButton = UIButton()
    var friendsCountButton: UIButton = UIButton()
    var friendsCountIcon: UIButton = UIButton()
    var popularRankButton = UIButton()
    
    var settingsButton = UIButton()
    var mediaPickerHelper: MediaPickerHelper?
    
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
        
        configureProfilePic()
        configureBanner()
        configureUsernameButton()
        configureFriendDiamond()
        configurePopularRankButton()
        configureMessagesIcon()
        fetchUser()
        fetchDimes()
        configureUserSpecificButtons()
        configureSettingsButton()
        
    }
    
    func fetchUser() {
        guard let profileUser = self.user else { return }
        
        DatabaseReference.users(uid: profileUser.uid).reference().observeSingleEvent(of: .value, with: { user in
            
            self.user = User(dictionary: user.value as! [String : AnyObject])
            
            self.configureFriendsCountButton()
        })
    }
    
    func configureUserSpecificButtons(){
        
        guard let profileUser = self.user else { return }
        
        if profileUser == self.store.currentUser {
            
            friendDiamond.isHidden = true
            friendDiamond.isEnabled = false
            
            settingsButton.isHidden = false
            settingsButton.isEnabled = true
            
            self.messagesButton.removeTarget(self, action: #selector(startChat), for: .touchUpInside)
            self.messagesButton.addTarget(self, action: #selector(showChats), for: .touchUpInside)
            
            
        }else{
            
            friendDiamond.isHidden = false
            friendDiamond.isEnabled = true
            
            settingsButton.isHidden = true
            settingsButton.isEnabled = false
            
            navBar.rightButton.image = nil
            navBar.rightButton.isEnabled = false
            
            self.messagesButton.removeTarget(self, action: #selector(showChats), for: .touchUpInside)
            self.messagesButton.addTarget(self, action: #selector(startChat), for: .touchUpInside)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDimes()
    }
    
    func configureBanner(){
        self.view.addSubview(banner)
        
        
        self.banner.translatesAutoresizingMaskIntoConstraints = false
        self.banner.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 5).isActive = true
        
        self.banner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.banner.leadingAnchor.constraint(equalTo: self.circleProfileView.centerXAnchor).isActive = true
        
        self.banner.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.13).isActive = true
        
        self.banner.backgroundColor = UIColor.dimeDarkBlue()
        
        self.view.bringSubview(toFront: self.circleProfileView)
        
    }
    
    
    
    func configureProfilePic() {
        self.view.addSubview(circleProfileView)
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 5).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        self.circleProfileView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.13).isActive = true
        self.circleProfileView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.24).isActive = true
        
        self.circleProfileView.addTarget(self, action: #selector(changeProfilePic), for: .touchUpInside)
        
        
        guard let profileUser = self.user else { return }
        
        
        self.circleProfileView.setImage(#imageLiteral(resourceName: "icon-defaultAvatar"), for: .normal)
        
        let profileImageKey = "\(profileUser.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage {
            self.circleProfileView.setImage(image.circle, for: .normal)
        }else{
            profileUser.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.setImage(image.circle, for: .normal)
                    self?.cache?.setObject(image.circle, forKey: profileImageKey)
                }else if error != nil {
                    print("\(error?.localizedDescription)")
                }
            }
        }
        
        setImageViewCircular()
        
        
    }
    
    func setImageViewCircular() {
        self.view.layoutIfNeeded()
        self.circleProfileView.contentMode = .scaleAspectFit
        self.circleProfileView.isUserInteractionEnabled = true
        self.circleProfileView.layer.cornerRadius = self.circleProfileView.frame.size.width / 2
        self.circleProfileView.layer.borderColor = UIColor.white.cgColor
        self.circleProfileView.layer.borderWidth = 3.0
        self.circleProfileView.clipsToBounds = true
    }
    
    func changeProfilePic() {
        guard let profileUser = user else {
            print("There was an error unwrapping the User in changeProfilePic in ProfileCollectionVC")
            return
        }
        let editPictureAlert = UIAlertController(title: "Edit Profile Pic", message: nil, preferredStyle: .actionSheet)
        let editPictureAction = UIAlertAction(title: "Change Profile Picture", style: .default) { (edit) in
            self.mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { [weak self] (mediaObject) in
                guard let strongSelf = self else {
                    return
                }
                if let snapshotImage = mediaObject as? UIImage {
                    strongSelf.cache?.setObject(snapshotImage.circle, forKey: "\(profileUser.uid)-profileImage")
                    strongSelf.store.currentUser?.profileImage = snapshotImage
                    profileUser.profileImage = snapshotImage
                    strongSelf.circleProfileView.setImage(profileUser.profileImage?.circle, for: .normal)
                    print("Image successfully uploaded!")
                    profileUser.save(completion: { (nil) in
                            print("Profile pic saved to Firebase!")
                    })
                }
            })
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        editPictureAlert.addAction(editPictureAction)
        editPictureAlert.addAction(cancelAction)
        present(editPictureAlert, animated: true, completion: nil)
    }
    
    
    func configureFriendDiamond() {
        self.banner.addSubview(friendDiamond)
        
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        if currentUser.topFriends.contains(profileUser){
            self.friendDiamond.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
        }else if currentUser.friends.contains(profileUser){
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-Gray"), for: .normal)
        }else{
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blueDiamondUnfilled"), for: .normal)
        }
        
        friendDiamond.titleLabel?.font = UIFont.dimeFont(16)
        friendDiamond.setTitleColor(UIColor.black, for: .normal)
        friendDiamond.tintColor = UIColor.black
        friendDiamond.addTarget(self, action: #selector(filterFriendAlert), for: .touchUpInside)
        
        self.friendDiamond.translatesAutoresizingMaskIntoConstraints = false
        self.friendDiamond.topAnchor.constraint(equalTo: self.banner.topAnchor, constant: 10).isActive = true
        self.friendDiamond.trailingAnchor.constraint(equalTo: self.banner.trailingAnchor, constant: -10).isActive = true
        self.friendDiamond.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.friendDiamond.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.08).isActive = true
    }
    
    func configureUsernameButton() {
        self.banner.addSubview(userNameButton)
        
        guard let profileUser = user else { return }
        
        self.userNameButton.translatesAutoresizingMaskIntoConstraints = false
        self.userNameButton.topAnchor.constraint(equalTo: self.banner.topAnchor, constant: 5).isActive = true
        self.userNameButton.centerXAnchor.constraint(equalTo: self.banner.centerXAnchor).isActive = true
        self.userNameButton.heightAnchor.constraint(equalTo: self.banner.heightAnchor, multiplier: 0.5).isActive = true
        self.userNameButton.widthAnchor.constraint(equalTo: self.banner.widthAnchor, multiplier: 0.7).isActive = true
        
        userNameButton.titleLabel?.font = UIFont.dimeFontBold(30)
        
        
        userNameButton.setTitle("\(profileUser.username)", for: .normal)
        userNameButton.setTitleColor(UIColor.white, for: .normal)
        userNameButton.titleLabel?.textAlignment = .center
        userNameButton.titleLabel?.font = UIFont.dimeFontBold(30)
        
        
    }
    
    func configurePopularRankButton(){
        
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        self.banner.addSubview(popularRankButton)
        popularRankButton.titleLabel?.font = UIFont.dimeFont(16)
        popularRankButton.setTitleColor(UIColor.white, for: .normal)
        
        popularRankButton.tintColor = UIColor.black
        //popularRankButton.addTarget(self, action: #selector(showPopularPage), for: .touchUpInside)
        
        self.popularRankButton.translatesAutoresizingMaskIntoConstraints = false
        self.popularRankButton.leadingAnchor.constraint(equalTo: self.userNameButton.leadingAnchor).isActive = true
        self.popularRankButton.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor, constant: -7).isActive = true
        
        self.popularRankButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.04).isActive = true
        self.popularRankButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.08).isActive = true
        
        
        if currentUser.friends.contains(profileUser){
            let friendIndex = currentUser.friends.index(of: profileUser)
            self.popularRankButton.setTitle(currentUser.friends[friendIndex!].popularRank.description, for: .normal)
            self.popularRankButton.titleLabel?.font = UIFont.dimeFont(12)
            self.popularRankButton.setTitleColor(UIColor.white, for: .normal)
            self.popularRankButton.titleLabel?.textAlignment = .right
            popularRankButton.setBackgroundImage(#imageLiteral(resourceName: "icon-popularGray"), for: .normal)
        }else{
            popularRankButton.setTitle("", for: .normal)
            popularRankButton.setBackgroundImage(nil, for: .normal)
        }
        
    }
    
    func configureMessagesIcon() {
        self.view.addSubview(messagesButton)
        messagesButton.setImage(#imageLiteral(resourceName: "icon-chatWhite"), for: .normal)
        messagesButton.imageView?.alpha = 0.5
        messagesButton.imageView?.contentMode = .scaleAspectFill
        messagesButton.imageView?.tintColor = UIColor.white
        
        self.messagesButton.translatesAutoresizingMaskIntoConstraints = false
        self.messagesButton.centerXAnchor.constraint(equalTo: self.banner.centerXAnchor).isActive = true
        self.messagesButton.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor, constant: -2).isActive = true
        
        self.messagesButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.messagesButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.10).isActive = true
    }
    
    
    
    
    
    func configureFriendsCountButton() {
        self.view.addSubview(friendsCountButton)
        
        guard let profileUser = user else { return }
        guard let currentUser = self.store.currentUser else { return }
        
        self.friendsCountButton.translatesAutoresizingMaskIntoConstraints = false
        self.friendsCountButton.trailingAnchor.constraint(equalTo: self.friendDiamond.trailingAnchor).isActive = true
        self.friendsCountButton.bottomAnchor.constraint(equalTo: self.banner.bottomAnchor, constant: -3).isActive = true
        
        self.friendsCountButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.04).isActive = true
        self.friendsCountButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.15).isActive = true
        
        
        friendsCountButton.addTarget(self, action: #selector(showAllFriends), for: .touchUpInside)
        
        friendsCountButton.setTitle("💎 \(profileUser.friends.count)", for: .normal)
        self.friendsCountButton.titleLabel?.font = UIFont.dimeFontBold(15)
        self.friendsCountButton.setTitleColor(UIColor.white, for: .normal)
        
    }
    
    
    
    func configureSettingsButton() {
        
        self.view.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.trailingAnchor.constraint(equalTo: banner.trailingAnchor).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: userNameButton.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.04).isActive = true
        settingsButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.1).isActive = true
        
        settingsButton.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        
        settingsButton.setImage(#imageLiteral(resourceName: "icon-settings"), for: .normal)
        
    }
    
    func settingsButtonTapped() {
        
        let alertVC = UIAlertController(title: "Settings", message: nil, preferredStyle: .actionSheet)
        let draftsAction = UIAlertAction(title: "Drafts", style: .default) { [weak self] (drafts) in
            guard let strongSelf = self else {
                return
            }
            let draftsStoryboard = UIStoryboard(name: "Drafts", bundle: nil)
            if let draftsVC = draftsStoryboard.instantiateInitialViewController() {
                strongSelf.present(draftsVC, animated: true, completion: nil)
            }
        }
        let profilePicAction = UIAlertAction(title: "Change Profile Pic", style: .default) { [weak self] (changePic) in
            guard let strongSelf = self else {
                return
            }
            strongSelf.changeProfilePic()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in }
        let logOutAction = UIAlertAction(title: "Log Out", style: .default) { [weak self] (logOut) in
            guard let strongSelf = self else {
                return
            }
            do {
                try FIRAuth.auth()?.signOut()
                strongSelf.store.currentUser?.unregisterToken()
            } catch {
                print("There was an error logging out the user from the ProfileCollectionVC: \(error.localizedDescription)")
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "initialLogin")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let transition = CATransition()
            transition.type = kCATransitionFade
            appDelegate.window!.setRootViewController(loginVC, transition: transition)
        }
        
        alertVC.addAction(draftsAction)
        alertVC.addAction(profilePicAction)
        alertVC.addAction(logOutAction)
        alertVC.addAction(cancelAction)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    func showAllFriends(){
        
        let destinationVC = SearchDimeViewController()
        destinationVC.user = self.user
        destinationVC.viewContollerType = SearchViewControllerType.friends
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    
    
    func fetchDimes() {
        self.dimeCollectionView.reloadData()
        Dime.observeNewDimeForUser(user: user!, { (dime) in
            
            if !self.passedDimes.contains(dime) {
                self.passedDimes.insert(dime, at: 0)
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
        
        cell.parentCollectionView = self
        cell.collectionView = dimeCollectionView
        
        cell.currentUser = store.currentUser
        cell.dime = passedDimes[indexPath.row]
        
        
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
        self.dimeCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
        
        let _ = self.navigationController?.popViewController(animated: true)
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
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
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
