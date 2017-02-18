//
//  ChatTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 1/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit
import SAMCache

class ChatTableViewCell: UITableViewCell {
    
    lazy var featuredImageView      : UIImageView   = UIImageView()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var titleLabel             : UILabel       = UILabel()
    lazy var lastMessageLabel       : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    lazy var averageLikesLabel      : UILabel       = UILabel()
    
    weak var parentTableView = UIViewController()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    
    var chat: Chat! {
        didSet{
            self.updateUI()
        }
    }
    
    func updateUI(){
        
       featuredImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        let featuredImageViewKey = "\(self.chat.title)-titleImage"
        
        if let image = cache?.object(forKey: featuredImageViewKey) as? UIImage
        {
            self.featuredImageView.image = image
        }else{

        chat.downloadFeaturedImage { (image, error) in
            self.featuredImageView.image = image
            self.cache?.setObject(image, forKey: featuredImageViewKey)    
            
        }

        
        }
    
        self.setImageViewCircular()

        
        titleLabel.text = chat.title
        titleLabel.font = UIFont.dimeFontBold(14)
        titleLabel.textColor = UIColor.black
        
        lastMessageLabel.text = chat.lastMessage
        lastMessageLabel.font = UIFont.dimeFont(13)
        lastMessageLabel.textColor = UIColor.lightGray
        
        timeAgoLabel.text = parseDate(chat.lastUpdate)
        timeAgoLabel.font = UIFont.dimeFontBold(10)
        timeAgoLabel.textColor = UIColor.lightGray
        
    }
    
    
    func setViewConstraints() {
        
        
        self.featuredImageView.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.averageLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.featuredImageView)
        self.featuredImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.featuredImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.featuredImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.featuredImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.averageLikesLabel)
        self.averageLikesLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.averageLikesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -11.5).isActive = true
        self.averageLikesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.averageLikesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        
        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.averageLikesLabel.leadingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.featuredImageView.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.65).isActive = true
        self.mainLabelStackview.addArrangedSubview(self.titleLabel)
        self.mainLabelStackview.addArrangedSubview(self.lastMessageLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    
    func setImageViewCircular() {
        self.featuredImageView.contentMode = .scaleAspectFill
        self.featuredImageView.isUserInteractionEnabled = true
        self.featuredImageView.layer.cornerRadius = self.frame.height * profileImageHeightMultiplier / 2
        self.featuredImageView.layer.borderColor = UIColor.black.cgColor
        self.featuredImageView.layer.borderWidth = borderWidth
        self.featuredImageView.clipsToBounds = true
    }
    
    fileprivate func parseDate(_ date : String) -> String {
        
        if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
            return timeAgo
        }
        else { return "" }
    }



}
