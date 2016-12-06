import UIKit
import SAMCache

class DimeCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView : UIImageView!
    var circleProfileView = UIImageView()
    
    var captionLabel = UILabel()
    var locationLabel = UILabel()
    var createdTimeLabel = UILabel()
    var carrierLabel = UILabel()
    
    var dismiss = UIButton()
    var priceButton = UIButton()
    var likeButton = UIButton()
    
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
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        
        configureBackgroundImage()
        configureBlurEffect()
        configureImageView()
        configureProfilePic()
       // configureLocationLabel()
//        configureHomeButton()
//        configureFavoriteButton()
//        configureCreatedTimeLabel()
//        configurePriceButton()
//       configureCaptionLabel()
    }
    
    
    func updateUI() {
        //circleProfileView.image = dime.createdBy.profileImage
//        imageView.image = dime.media[0].mediaImage
        createdTimeLabel.text = dime.createdTime.description
        
       // profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        if let image = cache?.object(forKey: "\(self.dime.media[0].uid)-coverImage") as? UIImage
            {
                self.imageView.image = image
        }else {
            dime.media[0].downloadMediaImage(completion: { [weak self] (image, error) in
                if let image = image {
                    self?.imageView.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.dime.media[0].uid)-coverImage")
                }
            })
        }

        if let image = cache?.object(forKey: "\(self.dime.createdBy.uid)-profileImage") as? UIImage {
            self.circleProfileView.image = image
        }else{
            
            dime.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.dime.createdBy.uid)- profileImage")
                }else if error != nil {
                    print(error)
                }
            }
        }
        
        circleProfileView.layer.cornerRadius = circleProfileView.bounds.width / 2.0
        circleProfileView.layer.masksToBounds = true
        
        
        
//        usernameButton.setTitle(media.createdBy.username, for: [])
//        
//        followButton.layer.borderWidth = 1
//        followButton.layer.cornerRadius = 2.0
//        followButton.layer.borderColor = followButton.tintColor.cgColor
//        followButton.layer.masksToBounds = true
//        
//        if currentUser.follows.contains(media.createdBy) || media.createdBy.uid == currentUser.uid {
//            followButton.isEnabled = true
//        }else {
//            followButton.isHidden = false
//        }
    
    }
    
    
    
//    func configureCreatedTimeLabel() {
//        contentView.addSubview(createdTimeLabel)
//        
//        createdTimeLabel.font = UIFont.dimeFont(12)
//        createdTimeLabel.textColor = UIColor.white
//        
//        self.createdTimeLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.createdTimeLabel.bottomAnchor.constraint(equalTo: self.carrierLabel.topAnchor, constant: -1).isActive = true
//        self.createdTimeLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
//    }
//    
    
    func configureProfilePic() {
        contentView.addSubview(circleProfileView)
        circleProfileView.contentMode = UIViewContentMode.scaleAspectFill
        circleProfileView.clipsToBounds = true
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true

        self.circleProfileView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.2).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    
//    func configureLocationLabel() {
//        contentView.addSubview(locationLabel)
//        
//        locationLabel.font = UIFont.dimeFont(28)
//        locationLabel.textColor = UIColor.white
//        locationLabel.textAlignment = .right
//        locationLabel.adjustsFontSizeToFitWidth = true
//        
//        self.locationLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.locationLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -15).isActive = true
//        self.locationLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
//        self.locationLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
//    }
    
    
//    func configureSnippetLabel() {
//        contentView.addSubview(captionLabel)
//        
//        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.captionLabel.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 10).isActive = true
//        self.captionLabel.bottomAnchor.constraint(equalTo: self.priceButton.topAnchor, constant: -5).isActive = true
//        self.captionLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 15).isActive = true
//        self.captionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -15).isActive = true
//
//        captionLabel.backgroundColor = UIColor.clear
//        captionLabel.textAlignment = NSTextAlignment.left
//        captionLabel.textColor = UIColor.white
//        captionLabel.text = "No Information"
//        
//    }
    
    
    func configureBackgroundImage() {
        contentView.addSubview(backgroundLocationImage)
        
        backgroundLocationImage.contentMode = UIViewContentMode.scaleAspectFill
        backgroundLocationImage.clipsToBounds = true
        
        self.backgroundLocationImage.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundLocationImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.backgroundLocationImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.backgroundLocationImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.backgroundLocationImage.heightAnchor.constraint(equalTo: self.contentView.heightAnchor).isActive = true
    }
    
    
    func configureBlurEffect() {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.contentView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 1
        
        contentView.addSubview(blurEffectView)
    }
    
    
    func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -50).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.35).isActive = true
    }
    

    
    
//    func configureHomeButton() {
//        contentView.addSubview(dismiss)
//        
//        self.dismiss.translatesAutoresizingMaskIntoConstraints = false
//        self.dismiss.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 25).isActive = true
//        self.dismiss.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
//        
//        likeButton.titleLabel?.font = UIFont.dimeFont(16)
//        dismiss.titleLabel?.textColor = UIColor.white
//        dismiss.setTitle("home", for: .normal)
//    }
//    
    
//    func configurePriceButton() {
//        contentView.addSubview(priceButton)
//        
//        priceButton.titleLabel?.font = UIFont.dimeFont(16)
//        priceButton.titleLabel?.textColor = UIColor.white
//        priceButton.titleLabel?.shadowColor = UIColor.white
//        
//        self.priceButton.translatesAutoresizingMaskIntoConstraints = false
//        self.priceButton.bottomAnchor.constraint(equalTo: self.createdTimeLabel.topAnchor, constant: -3).isActive = true
//        self.priceButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant:-20).isActive = true
//        self.priceButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
//    }
//    
    
//    func configureFavoriteButton() {
//        contentView.addSubview(likeButton)
//        
//        likeButton.translatesAutoresizingMaskIntoConstraints = false
//        likeButton.centerYAnchor.constraint(equalTo: dismiss.centerYAnchor).isActive = true
//        likeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
//        
//        likeButton.titleLabel?.textColor = UIColor.white
//        likeButton.showsTouchWhenHighlighted = true
//    }
//    
//    func toggleFavoriteButton() {
//        if likeButton.titleLabel?.text == "◎" {
//            likeButton.setTitle("◉", for: .normal)
//        } else {
//            likeButton.setTitle("◎", for: .normal)
//        }
//    }
//    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}







}










