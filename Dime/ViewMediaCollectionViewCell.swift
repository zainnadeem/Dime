//
//  ViewMediaCollectionViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 12/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache
import AVKit
import AVFoundation
import OneSignal

class ViewMediaCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView = UIButton()
    
    //var captionLabel = UILabel()
    var locationLabel = UILabel()
    var createdTimeLabel = UILabel()
    var captionLabel = UILabel()
    var likesLabel = UILabel()
    var superLikeLabel = UILabel()
    var dismiss = UIButton()
    var usernameButton = UIButton()
    var superLikeButton = UIButton()
    var viewCommentsButton = UIButton()
    var background: UIImageView = UIImageView()
    var playButton = UIButton()
    
  
    weak var parentCollectionView       =       UIViewController()
   
    lazy var likeButton               :  UIButton       = UIButton(type: .custom)
    
    lazy var isLikedByUser            :  Bool           = Bool()
    
    lazy var isSuperLikedByUser       : Bool            = Bool()
    lazy var canSuperLike             : Bool            = Bool()
    
    var currentUser: User!
    var dime: Dime!
    var media: Media! {
        didSet{
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        configureCaptionNameLabel()
        configureImageView()
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        configureCreatedTimeLabel()
        configureViewCommentsButton()
        self.backgroundColor = UIColor.clear
        
    }
    
    
    func updateUI() {
        
        self.imageView.setImage(#imageLiteral(resourceName: "LoadingDimeImageWhite"), for: .normal)
        self.playButton.setImage(nil, for: .normal)
        
        let mediaImageKey = "\(media.uid)-mediaImage"
       
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            self.imageView.setImage(image, for: .normal)
            self.setUpVideoButton()
        }else {
            media.downloadMediaImage(completion: { [weak self] (image, error) in
                if let image = image {
                    self?.imageView.setImage(image, for: .normal)
                    self?.setUpVideoButton()
                    self?.cache?.setObject(image, forKey: "\(self?.media.uid)-mediaImage")
                }
            })
        }
        
        self.imageView.imageView?.contentMode = .scaleAspectFit
        
        captionLabel.text = media.caption
        captionLabel.textColor = UIColor.white
        
        createdTimeLabel.textColor = UIColor.white
        createdTimeLabel.text = parseDate(media.createdTime)
        
        
        setUpLikeButton()
        setUpSuperLikeButton()
        configureSuperLikeFunctionality()


        
        if media.comments.count == 0{
            viewCommentsButton.setTitle("Be the first to comment!", for: .normal)
        }else if media.comments.count == 1 {
            viewCommentsButton.setTitle("\(media.comments.count) comment", for: .normal)
        }else{
            viewCommentsButton.setTitle("\(media.comments.count) comments", for: .normal)
        }
        
        likesLabel.text = media.likesCount.description
        superLikeLabel.text = media.superLikesCount.description
        
       
    }
    
    func setUpLikeButton(){
        if media.likes.contains(currentUser){
            self.isLikedByUser = true
            likeButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
        }else{
            self.isLikedByUser = false
            likeButton.setImage(#imageLiteral(resourceName: "friendsHomeUnfilled"), for: .normal)
        }
        
    }
    
    func setUpVideoButton(){
        if media.type == "video" {
            configurePlayButton()
            playButton.isEnabled = true
        }else{
            playButton.setImage(nil, for: .normal)
            playButton.isEnabled = false
        }
    }
    
    func setUpSuperLikeButton(){
        if media.superLikes.contains(currentUser){
            self.isSuperLikedByUser = true
            superLikeButton.setImage(#imageLiteral(resourceName: "topDimesHome"), for: .normal)
            
        }else{
            self.isSuperLikedByUser = false
            superLikeButton.setImage(#imageLiteral(resourceName: "topDimesHomeUnfilled"), for: .normal)
        }
        
    }
    
    func configureSuperLikeFunctionality(){
        if self.didSuperLikeWithinOneDay(superLikeDate: self.currentUser!.lastSuperLikeTime) || isSuperLikedByUser == true{
            canSuperLike = false
            self.superLikeButton.removeTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
            self.superLikeButton.addTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
        }else{
            canSuperLike = true
            self.superLikeButton.removeTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
            self.superLikeButton.addTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
        }
    }
    
    
    func configurePlayButton(){
        contentView.addSubview(playButton)
        playButton.setImage(#imageLiteral(resourceName: "playIcon"), for: .normal)
        
        self.playButton.addTarget(self, action: #selector(createVideoPlayer), for: .touchUpInside)
        self.playButton.translatesAutoresizingMaskIntoConstraints = false
        self.playButton.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        self.playButton.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor).isActive = true
        
        self.playButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1).isActive = true
        
    }
    
    func createVideoPlayer() {
        
            media.downloadVideo(completion: { (url, error) in
                if error != nil{
                    
                    let alertVC = UIAlertController(title: "sorry", message: "There was an error loading this video", preferredStyle: .alert)
                    let cancel = UIAlertAction(title: "okay", style: .cancel, handler: nil)
                    alertVC.addAction(cancel)
                    
                    self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
                
                }else{
                    
                    guard let link = url else { return }

                    let player = AVPlayer(url: link)
                    
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    
                    let parentView = self.viewController()
                    
                    parentView?.present(playerViewController, animated: true, completion: {
                        playerViewController.player?.play()
                    })
                }
            
            
            })
            
        }

    func showComments(){
        let destinationVC = CommentsViewController()
        destinationVC.modalPresentationStyle = .overCurrentContext
        destinationVC.media = self.media
        self.parentCollectionView?.present(destinationVC, animated: true, completion: nil)
    }
    
    func configureCaptionNameLabel() {
        contentView.addSubview(captionLabel)
        
        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.captionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 75).isActive = true
        self.captionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.captionLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        
        self.captionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        captionLabel.textAlignment = .center
        captionLabel.font = UIFont.dimeFontBold(14)
        captionLabel.textColor = UIColor.black
    }
    
    

    
    
    func configureImageView() {
        contentView.addSubview(imageView)

        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.captionLabel.bottomAnchor, constant: 5).isActive = true
        
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.55).isActive = true
        
        self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
    }
    

    
    func configureLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.titleLabel?.font = UIFont.dimeFont(20)
        
        
        self.likeButton.addTarget(self, action: #selector(likeUnLikeButtonTapped), for: .touchUpInside)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 10).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
      
        self.likeButton.layer.shadowColor = UIColor.white.cgColor
        self.likeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.likeButton.layer.shadowOpacity = 1.0
        self.likeButton.layer.shadowRadius = 2.0
        self.likeButton.layer.masksToBounds = false
        
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.white
        likesLabel.font = UIFont.dimeFontBold(14)
        
    
        
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant:2).isActive = true
        self.likesLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeButton(){
        contentView.addSubview(superLikeButton)
        superLikeButton.titleLabel?.font = UIFont.dimeFont(20)
       
        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeButton.leadingAnchor.constraint(equalTo: self.likesLabel.trailingAnchor, constant: 10).isActive = true
        self.superLikeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
        
        self.superLikeButton.layer.shadowColor = UIColor.white.cgColor
        self.superLikeButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.superLikeButton.layer.shadowOpacity = 1.0
        self.superLikeButton.layer.shadowRadius = 2.0
        self.superLikeButton.layer.masksToBounds = false
    }
    
    func configureSuperLikeLabel(){
        contentView.addSubview(superLikeLabel)
        superLikeLabel.backgroundColor = UIColor.clear
        superLikeLabel.textAlignment = NSTextAlignment.center
        superLikeLabel.textColor = UIColor.white
        superLikeLabel.font = UIFont.dimeFontBold(14)
        
 
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
    
    func configureViewCommentsButton(){
        contentView.addSubview(viewCommentsButton)
        viewCommentsButton.backgroundColor = UIColor.clear
        createdTimeLabel.textAlignment = NSTextAlignment.right
        createdTimeLabel.textColor = UIColor.black
        createdTimeLabel.font = UIFont.dimeFont(9)
        
        self.viewCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewCommentsButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        self.viewCommentsButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.viewCommentsButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.4).isActive = true
        self.viewCommentsButton.topAnchor.constraint(equalTo: self.likeButton.bottomAnchor, constant: 7).isActive = true
        
        viewCommentsButton.titleLabel?.textAlignment = .center
        viewCommentsButton.titleLabel?.textColor = UIColor.white
        viewCommentsButton.titleLabel?.font = UIFont.dimeFontBold(12)
        viewCommentsButton.addTarget(self, action: #selector(showComments), for: .touchUpInside)
    }
    
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    fileprivate func parseDate(_ date : String) -> String {
        
        if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
            return timeAgo
        }
        else { return "" }
    }
    
    
}

extension ViewMediaCollectionViewCell{
    
    
    
    
    
    func likeUnLikeButtonTapped() {
        
        let dimeRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/likes/\(currentUser.uid)")
        
        let mediaRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/media/\(media.uid)/likes/\(currentUser.uid)")
        
        if isLikedByUser{
            
            media.unlikedBy(user: currentUser)
            dime.unlikedBy(user: currentUser)
            
            dime.updateLikes(.decrement)
            media.updateLikes(.decrement)
            
            //find place for updating user
            
            mediaRef.setValue(nil)
            dimeRef.setValue(nil)
            
            likeButton.setImage(#imageLiteral(resourceName: "friendsHomeUnfilled"), for: .normal)
            isLikedByUser = false
            
        }else{
            
            media.likedBy(user: currentUser)
            dime.likedBy(user: currentUser)
            
            dime.updateLikes(.increment)
            media.updateLikes(.increment)
            
            createNotification(type: NotificationType.like)
            
            
            dimeRef.setValue(currentUser.toDictionary())
            mediaRef.setValue(currentUser.toDictionary())
            
            likeButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
            
            
            isLikedByUser = true
            
        }
        
        likesLabel.text = media.likesCount.description
        
    }
    
    func createNotification(type: NotificationType){
        
        let notification = Notification(dimeUID: self.media.dimeUID, mediaUID: self.media.uid, toUser: self.media.createdBy.uid, from: self.currentUser, caption: "\(self.currentUser.username) \(type)d your \(self.media.type)!", notificationType: type)
        
        notification.save()
    
        
        var heading = type.rawValue.substring(to: type.rawValue.index(before: type.rawValue.endIndex))
        
        
        for id in self.media.createdBy.deviceTokens{
            OneSignal.postNotification(["contents" : ["en" : "\(currentUser.username) \(type)d your post!"], "headings" : ["en" : "\(heading.capitalized)!"], "include_player_ids" : [id]])
        }
    }
    
    
    func reloadLabels(){
        if media.likes != [] {
            likesLabel.text = media.likesCount.description
        }else{
            likesLabel.text = "0"
        }
        
    }
    
}


//ViewMediaCollection Super Like Button
extension ViewMediaCollectionViewCell {
    
    func superLikeMedia() {
        
            media.superLikedBy(user: currentUser)
            let mediaRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(media.dimeUID)/media/\(media.uid)/superLikes/\(currentUser.uid)")
            mediaRef.setValue(currentUser.toDictionary())
        
            media.updateSuperLikes(.increment)
            dime.updateSuperLikes(.increment)
        
        
            superLikeButton.setImage(#imageLiteral(resourceName: "topDimesHome"), for: .normal)
            isSuperLikedByUser = true
        
            createNotification(type: NotificationType.superLike)
    }
    
    
    func didSuperLikeWithinOneDay(superLikeDate date : String) -> Bool {
        if let creationDate = Constants.dateFormatter().date(from: date) {
            
            let yesterday = Constants.dateFormatter().date(from: Constants.oneDayAgo())!
            
            if creationDate.compare(yesterday) == .orderedDescending { return true }
            else if creationDate.compare(yesterday) == .orderedSame  { return true }
            else { return false }
            
        } else {
            print("Couldn't get NSDate object from string date arguement")
            return false
        }
    }
    
    func superLikeAlert() {
        let alertVC = UIAlertController(title: "SuperLiked!", message: "You can only super like one dime every 24 hours, you cannot undo this action, is this your superlike today?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.currentUser.superLiked()
            self.superLikeMedia()
            self.canSuperLike = false
            self.updateUI()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alertVC.addAction(yesAction)
        alertVC.addAction(cancelAction)
        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
    }
    
    func cantSuperLikeAlert() {
        var message = ""
        if isSuperLikedByUser { message = "You've already superliked this one!"}else{ message = "You've already superliked today!"
        }
        
        let alertVC = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertVC.addAction(cancelAction)
        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
    }
    
}


