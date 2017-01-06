//
//  CommentTableViewCell.swift

//

import UIKit
import NSDate_TimeAgo
import SAMCache

class CommentTableViewCell: UITableViewCell {

    lazy var profileImage           : UIImageView   = UIImageView()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var fullName               : UILabel       = UILabel()
    lazy var commentLabel           : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    var cache = SAMCache.shared()
    

    var comment: Comment! {
        didSet {
            self.updateUI()
        }
    }

    
    func setViewConstraints() {
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.commentLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.profileImage)
        self.profileImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.profileImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.profileImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true

        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.65).isActive = true
        self.mainLabelStackview.addArrangedSubview(self.fullName)
        self.mainLabelStackview.addArrangedSubview(self.commentLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    

    func updateUI()
    {
        profileImage.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        let profileImageKey = "\(self.comment.from.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage
        {
            self.profileImage.image = image
        }else{
        comment.from.downloadProfilePicture { [weak self] (image, error) in
            self?.profileImage.image = image
            self?.cache?.setObject(image, forKey: profileImageKey)
        }
        }
        
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.masksToBounds = true
        setImageViewCircular()
        fullName.text = comment.from.fullName
        fullName.textColor = UIColor.white
        fullName.font = UIFont.dimeFontBold(12)
        
        commentLabel.text = comment.caption
        commentLabel.textColor = UIColor.white
        commentLabel.font = UIFont.dimeFont(10)
        commentLabel.numberOfLines = 10
        
        timeAgoLabel.text = parseDate(comment.createdTime)
        //parseDate(business.latestVideo["dateCreated"] as! String)
        //timeAgoLabel.text = parse   comment.createdTime.description
        timeAgoLabel.textColor = UIColor.white
        timeAgoLabel.font = UIFont.dimeFont(10)
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
























