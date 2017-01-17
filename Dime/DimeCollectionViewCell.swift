import UIKit
import SAMCache

class DimeCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView = UIButton()
    var circleProfileView = UIButton()
    
    var captionLabel = UILabel()
    var locationLabel = UILabel()
    var createdTimeLabel = UILabel()
    var DimeNameLabel = UILabel()
    var likesLabel = UILabel()
    var superLikeLabel = UILabel()
    
    var dismiss = UIButton()
    var usernameButton = UIButton()
    var likeButton = UIButton()
    var superLikeButton = UIButton()
    var chatButton = UIButton()
    var popularRankButton = UIButton()
    var background: UIImageView = UIImageView()
    
    lazy var friendDiamond   :  UIButton       = UIButton()
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    weak var parentCollectionView = UIViewController()
    
    var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    lazy var isLikedByUser            : Bool          = Bool()
    lazy var isSuperLikedByUser       : Bool          = Bool()
    lazy var canSuperLike             : Bool          = Bool()
    
    let store = DataStore.sharedInstance
    var currentUser: User!
    var dime: Dime! {
        didSet{
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       // imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        //configureBackgroundImage()
        
        configureProfilePic()
        configureUsernameButton()
    
        configureFriendDiamond()
        configureChatButton()
        configurePopularRankButton()
        
        configureCaptionNameLabel()
        
        configureImageView()
        
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        configureCreatedTimeLabel()
        
        self.backgroundColor = UIColor.clear

    }
    
    func hideButtonsForUser(){
        if currentUser == dime.createdBy{
        self.chatButton.isHidden = true
        self.friendDiamond.isHidden = true
        }else{
            self.chatButton.isHidden = false
            self.friendDiamond.isHidden = false
            
        }
    }
    
    func updateUI() {
 
        hideButtonsForUser()
        //self.imageView.setImage(nil, for: .normal)
       
        
        let mediaImageKey = "\(self.dime.uid)-\(dime.createdTime)-coverImage"
        
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            
            self.imageView.setImage(image, for: .normal)

        }else {
            
            dime.downloadCoverImage(coverPhoto: mediaImageKey, completion: {  [weak self] (image, error)in
                self?.imageView.setImage(image, for: .normal)
                
                self?.cache?.setObject(image, forKey: mediaImageKey)
            })
        }
        
        self.circleProfileView.setImage(#imageLiteral(resourceName: "icon-defaultAvatar"), for: .normal)
        
        let profileImageKey = "\(self.dime.createdBy.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage {
            self.circleProfileView.setImage(image.circle, for: .normal)
        }else{
            dime.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.setImage(image.circle, for: .normal)
                    self?.cache?.setObject(image, forKey: profileImageKey)
                }else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        
        
        self.imageView.imageView?.contentMode = .scaleAspectFill
        self.circleProfileView.imageView?.contentMode = .scaleAspectFill
        
        // updateLabels()
        usernameButton.setTitle(dime.createdBy.fullName, for: .normal)
        usernameButton.addTarget(self, action: #selector(usernameButtonPressed), for: .touchUpInside)
        circleProfileView.addTarget(self, action: #selector(usernameButtonPressed), for: .touchUpInside)
        imageView.addTarget(self, action: #selector(showMedia), for: .touchUpInside)
        
        chatButton.addTarget(self, action: #selector(nextDidTap), for: .touchUpInside)
        captionLabel.text = dime.caption
        likesLabel.text = dime.totalDimeLikes.description
        createdTimeLabel.text = parseDate(dime.createdTime)
        
        if currentUser.friends.contains(dime.createdBy){
        let friendIndex = currentUser.friends.index(of: dime.createdBy)
        self.popularRankButton.setTitle(currentUser.friends[friendIndex!].popularRank.description, for: .normal)
        self.popularRankButton.titleLabel?.textColor = UIColor.black
        self.popularRankButton.titleLabel?.textAlignment = .center
        popularRankButton.setBackgroundImage(#imageLiteral(resourceName: "popularHome"), for: .normal)
        }else{
            popularRankButton.setTitle("", for: .normal)
            popularRankButton.setBackgroundImage(nil, for: .normal)
        }
        configureFriendButton()
        
    }
    
    func showMedia(){
        
        let destinationVC = ViewMediaCollectionViewController()
        destinationVC.passedDime = dime
        self.parentCollectionView?.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func showPopularPage() {
        self.parentCollectionView?.navigationController?.tabBarController?.selectedIndex = 4
   
    }
    
    
 
    
    func configureFriendButton(){
        if currentUser.topFriends.contains(dime.createdBy){
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
        }else if currentUser.friends.contains(dime.createdBy){
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blueDiamond"), for: .normal)
        }else{
            friendDiamond.setImage(#imageLiteral(resourceName: "icon-blueDiamondUnfilled"), for: .normal)
        }
    }
    
    func filterFriendAlert(){
            let actionSheet = UIAlertController(title: "\(dime.createdBy.username)", message: "Where would you like to put \(dime.createdBy.username)", preferredStyle: .actionSheet)
            
            let topFriends = UIAlertAction(title: "Top Dimes", style: .default, handler: {
                action in
                
                
                self.currentUser.topFriendUser(user: self.dime.createdBy)
                self.currentUser.friendUser(user: self.dime.createdBy)
                self.dime.createdBy.getTotalLikes()
                self.configureFriendButton()
                
                
            })

            let friend = UIAlertAction(title: "Friends", style: .default, handler: {
                action in
                
                self.currentUser.friendUser(user: self.dime.createdBy)
                self.currentUser.unTopFriendUser(user: self.dime.createdBy)
                self.dime.createdBy.getTotalLikes()
                self.configureFriendButton()
                
                
            })
            
        
            let unfriend = UIAlertAction(title: "Unfriend", style: .default, handler: {
                action in
                
                self.currentUser.unTopFriendUser(user: self.dime.createdBy)
                self.currentUser.unFriendUser(user: self.dime.createdBy)
                self.configureFriendButton()
                
                
            })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            action in
            print("Canceled")
        })
            
            
            actionSheet.addAction(topFriends)
            actionSheet.addAction(friend)
        if currentUser.topFriends.contains(dime.createdBy) || currentUser.friends.contains(dime.createdBy){
            actionSheet.addAction(unfriend)
        }
            actionSheet.addAction(cancel)
            self.parentCollectionView?.present(actionSheet, animated: true, completion: nil)
        }
    

    
    
    func configureProfilePic() {
        contentView.addSubview(circleProfileView)
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 130).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
        
        self.circleProfileView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.12).isActive = true
    }
    
    func configureUsernameButton() {
        contentView.addSubview(usernameButton)
        
        usernameButton.titleLabel?.font = UIFont.dimeFontBold(16)
        usernameButton.setTitleColor(UIColor.black, for: .normal)
        usernameButton.tintColor = UIColor.black
        
        self.usernameButton.translatesAutoresizingMaskIntoConstraints = false
        self.usernameButton.leadingAnchor.constraint(equalTo: self.circleProfileView.trailingAnchor, constant: 10).isActive = true
        self.usernameButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
        self.usernameButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
        self.usernameButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
    }
    
    func configureFriendDiamond(){
        contentView.addSubview(friendDiamond)
        friendDiamond.titleLabel?.font = UIFont.dimeFont(16)
        friendDiamond.setTitleColor(UIColor.black, for: .normal)
        friendDiamond.tintColor = UIColor.black
        friendDiamond.addTarget(self, action: #selector(filterFriendAlert), for: .touchUpInside)
        
        self.friendDiamond.translatesAutoresizingMaskIntoConstraints = false
        self.friendDiamond.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        self.friendDiamond.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
        self.friendDiamond.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07)
        self.friendDiamond.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.12)
        
    }

    
    func configureChatButton(){
        contentView.addSubview(chatButton)
        chatButton.titleLabel?.font = UIFont.dimeFont(16)
        chatButton.setTitleColor(UIColor.black, for: .normal)
        chatButton.setImage(#imageLiteral(resourceName: "icon-comment"), for: .normal)
        chatButton.tintColor = UIColor.black
        
        self.chatButton.translatesAutoresizingMaskIntoConstraints = false
        self.chatButton.trailingAnchor.constraint(equalTo: self.friendDiamond.leadingAnchor, constant: -20).isActive = true
        self.chatButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
        self.chatButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07)
        self.chatButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.12)
        
    }
    func configurePopularRankButton(){
        contentView.addSubview(popularRankButton)
        popularRankButton.titleLabel?.font = UIFont.dimeFont(16)
        popularRankButton.setTitleColor(UIColor.black, for: .normal)
       
        popularRankButton.tintColor = UIColor.black
        popularRankButton.addTarget(self, action: #selector(showPopularPage), for: .touchUpInside)
        
        self.popularRankButton.translatesAutoresizingMaskIntoConstraints = false
        self.popularRankButton.trailingAnchor.constraint(equalTo: self.chatButton.leadingAnchor, constant: -20).isActive = true
        self.popularRankButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
        self.popularRankButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.popularRankButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.12).isActive = true
        
        self.popularRankButton.titleLabel?.textAlignment = .center
        
    }
    
    func configureCaptionNameLabel() {
        contentView.addSubview(captionLabel)
        
        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.captionLabel.topAnchor.constraint(equalTo: self.circleProfileView.bottomAnchor, constant: 5).isActive = true
        self.captionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.captionLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        
        self.captionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        captionLabel.textAlignment = .center
        captionLabel.font = UIFont.dimeFont(14)
        captionLabel.textColor = UIColor.black
    }
    
    
    func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.captionLabel.bottomAnchor).isActive = true
        
        self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4).isActive = true
        
        self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    func configureLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.titleLabel?.font = UIFont.dimeFont(13)
        likeButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 10).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.black
        
        likesLabel.font = UIFont.dimeFontBold(13)
        
        
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant:2).isActive = true
        self.likesLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeButton(){
        contentView.addSubview(superLikeButton)
        superLikeButton.titleLabel?.font = UIFont.dimeFont(13)
        superLikeButton.setImage(#imageLiteral(resourceName: "topDimesHome"), for: .normal)
        
        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeButton.leadingAnchor.constraint(equalTo: self.likesLabel.trailingAnchor, constant: 10).isActive = true
        self.superLikeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        
        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
    }
    
    func configureSuperLikeLabel(){
        contentView.addSubview(superLikeLabel)
        superLikeLabel.backgroundColor = UIColor.clear
        superLikeLabel.textAlignment = NSTextAlignment.center
        superLikeLabel.textColor = UIColor.black
        superLikeLabel.font = UIFont.dimeFontBold(13)
//        superLikeLabel.text = "0"
        
        self.superLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeLabel.leadingAnchor.constraint(equalTo: self.superLikeButton.trailingAnchor, constant:2).isActive = true
        self.superLikeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.superLikeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.superLikeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureCreatedTimeLabel(){
        contentView.addSubview(createdTimeLabel)
        createdTimeLabel.backgroundColor = UIColor.clear
        createdTimeLabel.textAlignment = NSTextAlignment.right
        createdTimeLabel.textColor = UIColor.black
        createdTimeLabel.font = UIFont.dimeFont(9)
        
        self.createdTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdTimeLabel.leadingAnchor.constraint(equalTo: self.superLikeLabel.trailingAnchor, constant:2).isActive = true
        self.createdTimeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.createdTimeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.createdTimeLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -3).isActive = true
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewCircular() {
        self.circleProfileView.contentMode = .scaleAspectFill
        self.circleProfileView.isUserInteractionEnabled = true
        self.circleProfileView.layer.cornerRadius = self.frame.height * profileImageHeightMultiplier / 2
        self.circleProfileView.layer.borderColor = UIColor.black.cgColor
        self.circleProfileView.layer.borderWidth = borderWidth
        self.circleProfileView.clipsToBounds = true
    }
    

    
    func startChat(){
        //guard let chats = self.store.chats else { return }
        
        print("go to chat with user")
        
    }
    
    func usernameButtonPressed() {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = dime.createdBy
        self.parentCollectionView?.navigationController?.pushViewController(destinationVC, animated: true)
    }

}

//Hande messaging
extension DimeCollectionViewCell {
    
    func nextDidTap(){
        var conversationMembers = [dime.createdBy]
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
            
            let newChat = Chat(users: conversationMembers, title: title, featuredImageUID: conversationMembers.first!.uid)
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
        let chatVC = ChatViewController()
        
        chatVC.senderId = currentUser.uid
        chatVC.senderDisplayName = currentUser.fullName
        
        chatVC.currentUser = store.currentUser
        chatVC.chat = chat
        
        chatVC.hidesBottomBarWhenPushed = true
        
        self.parentCollectionView?.navigationController?.pushViewController(chatVC, animated: true)
        print("Not sure what the right bar button will do yet.")
    }
}

    fileprivate func parseDate(_ date : String) -> String {

        if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
            return timeAgo
        }
        else { return "" }
    }



// button
//extension DimeCollectionViewCell {

//func configureSuperLikeFunctionality(){
//    if self.didSuperLikeWithinOneDay(superLikeDate: self.currentUser!.lastSuperLikeTime) || isSuperLikedByUser == true{
//        canSuperLike = false
//        self.superLikeButton.removeTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
//        self.superLikeButton.addTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
//    }else{
//        canSuperLike = true
//        self.superLikeButton.removeTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
//        self.superLikeButton.addTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
//    }
//}
//
//    func superLikeUnLikeButtonTapped() {
//        if isSuperLikedByUser{
//            dime.unSuperLikedBy(user: currentUser)
//            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
//            dimeRef.setValue(nil)
//            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamondUnfilled"), for: .normal)
//            isSuperLikedByUser = false
//        }else{
//            dime.superLikedBy(user: currentUser)
//            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
//            dimeRef.setValue(currentUser.toDictionary())
//            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
//            isSuperLikedByUser = true
//        }
//        reloadLabels()
//    }
//    
//    
//    func reloadLabels(){
//        if dime.superLikes != [] {
//            superLikeLabel.text = dime.superLikes.count.description
//        }else{
//            superLikeLabel.text = "0"
//        }
//    }
//    
//    func didSuperLikeWithinOneDay(superLikeDate date : String) -> Bool {
//        if let creationDate = Constants.dateFormatter().date(from: date) {
//            
//            let yesterday = Constants.dateFormatter().date(from: Constants.oneDayAgo())!
//            
//            if creationDate.compare(yesterday) == .orderedDescending { return true }
//            else if creationDate.compare(yesterday) == .orderedSame  { return true }
//            else { return false }
//            
//        } else {
//            print("Couldn't get NSDate object from string date arguement")
//            return false
//        }
//    }
//    
//    func superLikeAlert() {
//        let alertVC = UIAlertController(title: "SuperLiked!", message: "You can only super like one dime every 24 hours, you cannot undo this action, is this your superlike today?", preferredStyle: .alert)
//        
//        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
//            self.currentUser.superLiked()
//            self.superLikeUnLikeButtonTapped()
//            self.canSuperLike = false
//            self.updateUI()
//        })
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        
//        
//        alertVC.addAction(yesAction)
//        alertVC.addAction(cancelAction)
//        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
//    }
//    
//    func cantSuperLikeAlert() {
//        var message = ""
//        if isSuperLikedByUser { message = "You've already superliked this one!"}else{ message = "You've already superliked today!"
//        }
//        
//        let alertVC = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
//        
//        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
//        
//        alertVC.addAction(cancelAction)
//        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
//    }
//    
//    fileprivate func parseDate(_ date : String) -> String {
//        
//        if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
//            return timeAgo
//        }
//        else { return "" }
//    }
//}

//Handle Messaging








