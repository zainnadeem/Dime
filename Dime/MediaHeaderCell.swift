//
//  MediaHeaderTableViewCell.swift
//  Moments
//
//  Created by Zain Nadeem on 11/15/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache

class MediaHeaderCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    var currentUser: User!
    var media: Media! {
        didSet{
            if currentUser != nil {
                self.updateUI()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    func updateUI(){
        profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        if let image = cache?.object(forKey: "\(self.media.createdBy.uid)-headerImage") as? UIImage {
            self.profileImageView.image = image
        }else{

            media.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.profileImageView.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.media.createdBy.uid)- headerImage")
                }else if error != nil {
                    print(error)
                }
            }
        }
        
         profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
         profileImageView.layer.masksToBounds = true
        
        usernameButton.setTitle(media.createdBy.username, for: [])
        
        followButton.layer.borderWidth = 1
        followButton.layer.cornerRadius = 2.0
        followButton.layer.borderColor = followButton.tintColor.cgColor
        followButton.layer.masksToBounds = true
        
        if currentUser.friends.contains(media.createdBy) || media.createdBy.uid == currentUser.uid {
            followButton.isEnabled = true
        }else {
            followButton.isHidden = false
        }
    }
   
    @IBAction func followButtonTapped(_ sender: Any) {
       currentUser.friendUser(user: media.createdBy)

    }

}
