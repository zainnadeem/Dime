//
//  CommentTableViewCell.swift

//

import UIKit
import NSDate_TimeAgo
import SAMCache

class NotificationsTableViewCell: UITableViewCell {
    
    lazy var profileImage           : UIButton      = UIButton()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var fullName               : UILabel       = UILabel()
    lazy var notificationLabel      : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    lazy var mediaButton            : UIButton      = UIButton()
    
    weak var parentTableView = UIViewController()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    
    var notification: Notification! {
        didSet {
            self.updateUI()
        }
    }
    
    
    func setViewConstraints() {
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.mediaButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.profileImage)
        self.profileImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.profileImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.profileImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.mediaButton)
        self.mediaButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mediaButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12.5).isActive = true
        self.mediaButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.mediaButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        mediaButton.addTarget(self, action: #selector(mediaButtonTapped), for: .touchUpInside)
        profileImage.addTarget(self, action: #selector(ProfileImageButtonTapped), for: .touchUpInside)
        
        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.mediaButton.leadingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.45).isActive = true
        //self.mainLabelStackview.addArrangedSubview(self.fullName)
        self.mainLabelStackview.addArrangedSubview(self.notificationLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    
    
    func updateUI()
    {
        
        profileImage.setImage(UIImage(named: "icon-defaultAvatar"), for: .normal)

        let profileImageKey = "\(self.notification.from.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage
        {
           self.profileImage.setImage(image, for: .normal)
       
        }else{
            notification.from.downloadProfilePicture { [weak self] (image, error) in
                self?.profileImage.setImage(image, for: .normal)
                self?.cache?.setObject(image, forKey: profileImageKey)
            }
        }
        
        self.mediaButton.setImage(nil, for: .normal)
        
        let mediaImageKey = "\(notification.mediaUID)-mediaImage"
        
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            self.mediaButton.setImage(image, for: .normal)
           
        }else {
            FIRImage.downloadImage(uid: notification.mediaUID, completion: { (image, error) in
                self.mediaButton.setImage(image, for: .normal)
                self.cache?.setObject(image, forKey: mediaImageKey)
            })
        }
    
        self.mediaButton.imageView?.contentMode = .scaleAspectFit
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.masksToBounds = true
        setImageViewCircular()
        fullName.text = notification.from.username
        fullName.textColor = UIColor.darkGray
        fullName.font = UIFont.dimeFontBold(12)
        
        notificationLabel.text = notification.caption
        notificationLabel.textColor = UIColor.black
        notificationLabel.font = UIFont.dimeFontBold(12)
        notificationLabel.numberOfLines = 10
        
        timeAgoLabel.text = parseDate(notification.createdTime)
        //parseDate(business.latestVideo["dateCreated"] as! String)
        //timeAgoLabel.text = parse   comment.createdTime.description
        timeAgoLabel.textColor = UIColor.black
        timeAgoLabel.font = UIFont.dimeFont(10)
    }
    
    func mediaButtonTapped(){
        print("Segue to media")
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = store.currentUser
        self.parentTableView?.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    
    func ProfileImageButtonTapped(){
        print("Segue to user")
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = notification.from
        self.parentTableView?.navigationController?.pushViewController(destinationVC, animated: true)
        
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
























