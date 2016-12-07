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
    var likesLabel = UILabel()
    var superLikeLabel = UILabel()
    
    var dismiss = UIButton()
    var usernameButton = UIButton()
    var likeButton = UIButton()
    var superLikeButton = UIButton()
    var background: UIImageView = UIImageView()
    
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
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        self.backgroundColor = UIColor.clear

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
        DimeNameLabel.textColor = UIColor.black
        
    
    }

    
    func configureProfilePic() {
        contentView.addSubview(circleProfileView)
        circleProfileView.contentMode = UIViewContentMode.scaleAspectFill
        circleProfileView.clipsToBounds = true
        circleProfileView.layer.cornerRadius = circleProfileView.bounds.width / 2.0
        circleProfileView.layer.masksToBounds = true
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 130).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true

        self.circleProfileView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.04).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07).isActive = true
    }

    func configureDimeNameLabel() {
        contentView.addSubview(DimeNameLabel)
        
        self.DimeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.DimeNameLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -10).isActive = true
        
        self.DimeNameLabel.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor).isActive = true
        
        self.DimeNameLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
        self.DimeNameLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.5)

        DimeNameLabel.backgroundColor = UIColor.clear
        DimeNameLabel.textAlignment = NSTextAlignment.center
        DimeNameLabel.textColor = UIColor.black
        DimeNameLabel.font = UIFont.dimeFont(13)
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
        
        self.imageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true
     
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.35).isActive = true
        
           self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.7).isActive = true
    }
    

    
    func configureUsernameButton() {
        contentView.addSubview(usernameButton)
        
        usernameButton.titleLabel?.font = UIFont.dimeFont(16)
        usernameButton.setTitleColor(UIColor.black, for: .normal)
        usernameButton.tintColor = UIColor.black
        
        self.usernameButton.translatesAutoresizingMaskIntoConstraints = false
        self.usernameButton.leadingAnchor.constraint(equalTo: self.circleProfileView.trailingAnchor, constant: 10).isActive = true
        self.usernameButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
        
       self.usernameButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
         self.usernameButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
    }
    
    func configureLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue"), for: .normal)
        likeButton.setTitle("10", for: .normal)
        likeButton.titleLabel?.font = UIFont.dimeFont(16)
  
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 5).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.black
        likesLabel.font = UIFont.dimeFont(9)
        likesLabel.text = "10"
        
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
        superLikeButton.titleLabel?.font = UIFont.dimeFont(16)
    
        
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
        superLikeLabel.textColor = UIColor.black
        superLikeLabel.font = UIFont.dimeFont(9)
        superLikeLabel.text = "0"
        
        self.superLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeLabel.leadingAnchor.constraint(equalTo: self.superLikeButton.trailingAnchor, constant:2).isActive = true
        self.superLikeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.superLikeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.superLikeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
//    func configureSuperLikeButton(){
//        superLikeButton.titleLabel?.font = UIFont.dimeFont(16)
//        superLikeButton.titleLabel?.textColor = UIColor.white
//        superLikeButton.titleLabel?.shadowColor = UIColor.white
//        
//        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
//        self.superLikeButton.leadingAnchor.constraint(equalTo: self.circleProfileView.trailingAnchor, constant: 10).isActive = true
//        self.superLikeButton.centerYAnchor.constraint(equalTo: self.circleProfileView.centerYAnchor).isActive = true
//        
//        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1)
//        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.3)
//    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
}







}










