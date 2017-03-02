
import UIKit
import NSDate_TimeAgo
import SAMCache


class PopularTableViewCell: UITableViewCell {
    
    lazy var profileImage           : UIImageView   = UIImageView()
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var fullName               : UILabel       = UILabel()
    lazy var notificationLabel      : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    lazy var averageLikesLabel      : UILabel       = UILabel()
    
    lazy var starImageView          : UIImageView   = UIImageView()
    lazy var poularRank             : UILabel       = UILabel()
    weak var parentTableView = UIViewController()
    
    lazy var borderWidth                  : CGFloat =       3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance

    
    
    func setViewConstraints() {
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.notificationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.averageLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.starImageView.translatesAutoresizingMaskIntoConstraints = false
        self.poularRank.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(self.profileImage)
        self.profileImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.profileImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12.5).isActive = true
        self.profileImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.profileImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.averageLikesLabel)
        self.averageLikesLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.averageLikesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -11.5).isActive = true
        self.averageLikesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.averageLikesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        
        self.contentView.addSubview(self.starImageView)
        self.starImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.starImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -11.5).isActive = true
        self.starImageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: profileImageHeightMultiplier).isActive = true
        self.starImageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.25*0.75).isActive = true
        self.starImageView.image = #imageLiteral(resourceName: "popularHome")
        
        self.contentView.addSubview(self.poularRank)
        self.poularRank.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.poularRank.centerXAnchor.constraint(equalTo: self.starImageView.centerXAnchor).isActive = true
        self.poularRank.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.2).isActive = true
        self.poularRank.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2).isActive = true
        
        
        
        // Main center labels stack
        self.contentView.addSubview(self.mainLabelStackview)
        self.mainLabelStackview.alignment = .leading
        self.mainLabelStackview.axis = .vertical
        self.mainLabelStackview.distribution = .fillProportionally
        
        self.mainLabelStackview.trailingAnchor.constraint(equalTo: self.averageLikesLabel.leadingAnchor).isActive = true
        self.mainLabelStackview.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.mainLabelStackview.leadingAnchor.constraint(equalTo: self.profileImage.trailingAnchor, constant: 7).isActive = true
        self.mainLabelStackview.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.65).isActive = true
        self.mainLabelStackview.addArrangedSubview(self.fullName)
        self.mainLabelStackview.addArrangedSubview(self.notificationLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        
    }
    
    
    func updateUI(user: User){
            self.profileImage.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            
            if let image = cache?.object(forKey: "\(user.uid)-headerImage") as? UIImage {
                self.profileImage.image = image
            }else{
                
                user.downloadProfilePicture { [weak self] (image, error) in
                    if let image = image {
                        self?.profileImage.image = image
                        self?.cache?.setObject(image, forKey: "\(user.uid)-headerImage")
                    }else if error != nil {
                        print("\(error?.localizedDescription)")
                    }
                }
            }
            

        
        fullName.text = user.fullName
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2.0
        profileImage.layer.masksToBounds = true
        setImageViewCircular()
        
        poularRank.text = user.averageLikesCount.description
        poularRank.textColor = UIColor.white
        poularRank.textAlignment = .center
        
        fullName.text = user.fullName
        fullName.textColor = UIColor.black
        fullName.font = UIFont.dimeFontBold(12)
        
        notificationLabel.textColor = UIColor.black
        notificationLabel.font = UIFont.dimeFontBold(12)
        notificationLabel.numberOfLines = 10
        

        timeAgoLabel.textColor = UIColor.black
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



