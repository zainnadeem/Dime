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
    var DimeNameLabel = UILabel()
    
    var dismiss = UIButton()
    var usernameButton = UIButton()
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
        configureImageView()
        configureProfilePic()
        configureUsernameButton()
        configureDimeNameLabel()

    }
    
    
    func updateUI() {
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
                    print(error?.localizedDescription)
                }
            }
        }
        
        circleProfileView.layer.cornerRadius = circleProfileView.bounds.width / 2.0
        circleProfileView.layer.masksToBounds = true
        usernameButton.setTitle(dime.createdBy.fullName, for: .normal)
        DimeNameLabel.text = "Dime Name"
        
    
    }
    
    
    func configureProfilePic() {
        contentView.addSubview(circleProfileView)
        circleProfileView.contentMode = UIViewContentMode.scaleAspectFill
        circleProfileView.clipsToBounds = true
        circleProfileView.layer.cornerRadius = circleProfileView.bounds.width / 2.0
        circleProfileView.layer.masksToBounds = true
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 115).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true

        self.circleProfileView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.10).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.15).isActive = true
    }

    func configureDimeNameLabel() {
        contentView.addSubview(DimeNameLabel)
        
        self.DimeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.DimeNameLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -10).isActive = true
        
        self.DimeNameLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.DimeNameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
        self.DimeNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)

        DimeNameLabel.backgroundColor = UIColor.clear
        DimeNameLabel.textAlignment = NSTextAlignment.center
        DimeNameLabel.textColor = UIColor.white
        DimeNameLabel.font = UIFont.dimeFont(13)
    }
    
    
    
    
    func configureBackgroundImage() {
        contentView.addSubview(backgroundLocationImage)
        backgroundLocationImage.image = #imageLiteral(resourceName: "background_BLUE")
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
        
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: -30).isActive = true
        self.imageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.35).isActive = true
    }
    

    
    func configureUsernameButton() {
        contentView.addSubview(usernameButton)
        
        usernameButton.titleLabel?.font = UIFont.dimeFont(16)
        usernameButton.titleLabel?.textColor = UIColor.white
        usernameButton.titleLabel?.shadowColor = UIColor.white
        
        self.usernameButton.translatesAutoresizingMaskIntoConstraints = false
        self.usernameButton.leadingAnchor.constraint(equalTo: self.circleProfileView.trailingAnchor, constant: 10).isActive = true
        self.usernameButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
       self.usernameButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
         self.usernameButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}







}










