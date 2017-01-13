//
//  ContactTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 1/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache


class ContactTableViewCell: UITableViewCell {
    
    lazy var profileImageView       : UIImageView   = UIImageView()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var displayNameLabel       : UILabel       = UILabel()
    lazy var fullName               : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    lazy var checkboxImageView      : UIImageView   = UIImageView()
    
    weak var parentTableView = UIViewController()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    
    var user: User! {
        didSet{
            self.updateUI()
        }
    }
    
    var added: Bool = false{
        didSet{
            if added == false {
                checkboxImageView.image = #imageLiteral(resourceName: "icon-checkbox")
            }else{
                checkboxImageView.image = #imageLiteral(resourceName: "icon-checkbox-filled")
            }
        }
    }
    
    func updateUI(){
        
        profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        let profileImageViewKey = "\(self.user.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageViewKey) as? UIImage
        {
            self.profileImageView.image = image
        }else{

        user.downloadProfilePicture { (image, error) in
            self.profileImageView.image = image
            self.cache?.setObject(image, forKey: profileImageViewKey)
           
            
        }
        
        }
        
        self.setImageViewCircular()
        
        displayNameLabel.text = user.username
        displayNameLabel.font = UIFont.dimeFontBold(14)
        displayNameLabel.textColor = UIColor.black
        
        fullName.text = user.fullName
        fullName.font = UIFont.dimeFont(12)
        fullName.textColor = UIColor.black
        
        
        checkboxImageView.image = #imageLiteral(resourceName: "icon-checkbox")
    }
    
    
    func setViewConstraints() {
        
        
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.displayNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.checkboxImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.profileImageView)
        self.profileImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.profileImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.profileImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.checkboxImageView)
        self.checkboxImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.checkboxImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -11.5).isActive = true
        self.checkboxImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier / 2).isActive = true
        self.checkboxImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75 / 2).isActive = true
        
        
        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.checkboxImageView.leadingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.profileImageView.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.65).isActive = true
        self.mainLabelStackview.addArrangedSubview(self.displayNameLabel)
        self.mainLabelStackview.addArrangedSubview(self.fullName)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    
    func setImageViewCircular() {
        self.profileImageView.contentMode = .scaleAspectFill
        self.profileImageView.isUserInteractionEnabled = true
        self.profileImageView.layer.cornerRadius = self.frame.height * profileImageHeightMultiplier / 2
        self.profileImageView.layer.borderColor = UIColor.black.cgColor
        self.profileImageView.layer.borderWidth = borderWidth
        self.profileImageView.clipsToBounds = true
    }


}
