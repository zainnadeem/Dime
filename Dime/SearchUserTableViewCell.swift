//
//  SearchUserTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 12/2/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache

class SearchUserTableViewCell: UITableViewCell {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    var cache = SAMCache.shared()
    
    func updateUI(user: User){
       self.profileImage.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        if let image = cache?.object(forKey: "\(user.uid)-headerImage") as? UIImage {
            self.profileImage.image = image
        }else{
            
            user.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                   // self?.profileImage.image = image
                    self?.cache?.setObject(image, forKey: "\(user.uid)-headerImage")
                }else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.masksToBounds = true
        usernameLabel.text = user.fullName
    }
    



}
