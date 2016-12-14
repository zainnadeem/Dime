//
//  ViewMediaCollectionViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 12/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache

class ViewMediaCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView : UIImageView!
    
    //var captionLabel = UILabel()
    var locationLabel = UILabel()
    var createdTimeLabel = UILabel()
    var captionLabel = UILabel()
    var likesLabel = UILabel()
    var superLikeLabel = UILabel()
    var dismiss = UIButton()
    var usernameButton = UIButton()
    var superLikeButton = UIButton()
    var background: UIImageView = UIImageView()
    
    lazy var likeButton      : UIButton      = UIButton(type: .custom)
    
    lazy var isLikedByUser       : Bool          = Bool()
    
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
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        configureBackgroundImage()
        configureImageView()
        configureDimeNameLabel()
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        self.backgroundColor = UIColor.clear
        
    }
    
    
    func updateUI() {
        
        // profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        if let image = cache?.object(forKey: "\(media.uid)-mediaImage") as? UIImage
        {
            self.imageView.image = image
        }else {
            media.downloadMediaImage(completion: { [weak self] (image, error) in
                if let image = image {
                    self?.imageView.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.media.uid)-mediaImage")
                }
            })
        }
        
        
        captionLabel.text = "Night Out"
        captionLabel.textColor = UIColor.black

        if media.likes.contains(currentUser){
            self.isLikedByUser = true
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue"), for: .normal)
        }else{
            self.isLikedByUser = false
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue2"), for: .normal)
        }
        reloadLabels()
    }
    
    
    func configureDimeNameLabel() {
        contentView.addSubview(captionLabel)
        
        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.captionLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -10).isActive = true
        
        self.captionLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        
        self.captionLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
        self.captionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)
        
        captionLabel.backgroundColor = UIColor.clear
        captionLabel.textAlignment = NSTextAlignment.center
        captionLabel.textColor = UIColor.black
        captionLabel.font = UIFont.dimeFont(13)
    }
    
    
    
    
    func configureBackgroundImage() {
        contentView.addSubview(backgroundLocationImage)
        backgroundLocationImage.image = background.image
        backgroundLocationImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundLocationImage.clipsToBounds = true
        
        self.backgroundLocationImage.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundLocationImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.backgroundLocationImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.backgroundLocationImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.backgroundLocationImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    }
    
    
    
    
    func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -10).isActive = true
        
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.35).isActive = true
        
        self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
    }
    
    
    
    
    func configureLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.titleLabel?.font = UIFont.dimeFont(20)
        
        self.likeButton.addTarget(self, action: #selector(likeUnLikeButtonTapped), for: .touchUpInside)
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 5).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
        
    }
    
    func likeUnLikeButtonTapped() {
        
        if isLikedByUser{
            media.unlikedBy(user: currentUser)
            dime.unlikedBy(user: currentUser)
            
            //find place for updating user
            let mediaRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/media/\(media.uid)/likes/\(currentUser.uid)")
            mediaRef.setValue(nil)
            
            let dimeRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/likes/\(currentUser.uid)")
            dimeRef.setValue(nil)
            
            
            
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue2"), for: .normal)
            isLikedByUser = false
        }else{
            media.likedBy(user: currentUser)
            dime.likedBy(user: currentUser)
            
             //find place for updating user
            let mediaRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/media/\(media.uid)/likes/\(currentUser.uid)")
            mediaRef.setValue(currentUser.toDictionary())
            
            let dimeRef = DatabaseReference.users(uid: media.createdBy.uid).reference().child("dimes/\(dime.uid)/likes/\(currentUser.uid)")
            dimeRef.setValue(currentUser.toDictionary())
            
            
            
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue"), for: .normal)
            isLikedByUser = true
        }
        reloadLabels()
    }
    
    
    
    func reloadLabels(){
        if media.likes != [] {
            likesLabel.text = media.likes.count.description
        }else{
            likesLabel.text = "0"
        }
        
        if dime.superLikes != [] {
            superLikeLabel.text = dime.superLikes.count.description
        }else{
            superLikeLabel.text = "0"
        }
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.white
        likesLabel.font = UIFont.dimeFont(9)
        
    
        
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant:2).isActive = true
        self.likesLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeButton(){
        contentView.addSubview(superLikeButton)
        superLikeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
        superLikeButton.setTitle("10", for: .normal)
        superLikeButton.titleLabel?.font = UIFont.dimeFont(20)
       
        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeButton.leadingAnchor.constraint(equalTo: self.likesLabel.trailingAnchor, constant: 5).isActive = true
        self.superLikeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5).isActive = true
        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeLabel(){
        contentView.addSubview(superLikeLabel)
        superLikeLabel.backgroundColor = UIColor.clear
        superLikeLabel.textAlignment = NSTextAlignment.center
        superLikeLabel.textColor = UIColor.white
        superLikeLabel.font = UIFont.dimeFont(9)
        
 
        self.superLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeLabel.leadingAnchor.constraint(equalTo: self.superLikeButton.trailingAnchor, constant:2).isActive = true
        self.superLikeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.superLikeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.superLikeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}
