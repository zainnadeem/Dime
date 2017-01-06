import UIKit
import SAMCache

class ProfileCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView : UIImageView!
    
    var captionLabel = UILabel()
    var locationLabel = UILabel()
    var createdTimeLabel = UILabel()
    var DimeNameLabel = UILabel()
    var likesLabel = UILabel()
    var superLikeLabel = UILabel()
    
    var dismiss = UIButton()
    var addToFriends = UIButton()
    var addToTopFriends = UIButton()
    var likeButton = UIButton()
    var superLikeButton = UIButton()
    var background: UIImageView = UIImageView()
    
    weak var parentCollectionView = UIViewController()
    
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
        configureDimeNameLabel()
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        addToFriendsButton()
        addToTopFriendsButton()
        self.backgroundColor = UIColor.clear
        
    }
    
    
    func updateUI() {
        createdTimeLabel.text = dime.createdTime.description
        
        self.imageView.image = nil
        
        let mediaImageKey = "\(self.dime.media[0].uid)-mediaImage"
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            self.imageView.image = image
        }else {
            dime.media[0].downloadMediaImage(completion: { [weak self] (image, error) in
                if let image = image {
                    self?.imageView.image = image
                    self?.cache?.setObject(image, forKey: mediaImageKey)
                }
            })
        }
        

        DimeNameLabel.text = "Dime Name"
        DimeNameLabel.textColor = UIColor.black
        
        
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
    
    
    
    func addToFriendsButton() {
        contentView.addSubview(addToFriends)
        
        addToFriends.titleLabel?.font = UIFont.dimeFont(40)
        addToFriends.setTitleColor(UIColor.dimeLightBlue(), for: .normal)
        addToFriends.setTitle("+", for: .normal)
        addToFriends.addTarget(self, action: #selector(addToFriendsTapped), for: .touchUpInside)
        
        
        self.addToFriends.translatesAutoresizingMaskIntoConstraints = false
        self.addToFriends.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.addToFriends.topAnchor.constraint(equalTo: self.imageView.topAnchor).isActive = true
        
        self.addToFriends.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1).isActive = true
        self.addToFriends.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1).isActive = true
    }
    
    func addToFriendsTapped(){
        currentUser.friendUser(user: dime.createdBy)
        
        print("added friend")
    }
    
    
    
    
    func addToTopFriendsButton() {
        contentView.addSubview(addToTopFriends)
        
        addToTopFriends.titleLabel?.font = UIFont.dimeFont(40)
        addToTopFriends.setTitleColor(UIColor.black, for: .normal)
        addToTopFriends.setTitle("+", for: .normal)
        addToTopFriends.addTarget(self, action: #selector(addToTopFriendsTapped), for: .touchUpInside)
        
        
        self.addToTopFriends.translatesAutoresizingMaskIntoConstraints = false
        self.addToTopFriends.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        self.addToTopFriends.topAnchor.constraint(equalTo: self.addToFriends.bottomAnchor, constant: 5).isActive = true
        
        self.addToTopFriends.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.1).isActive = true
        self.addToTopFriends.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.1).isActive = true
    }
    
    func addToTopFriendsTapped() {
        currentUser.topFriendUser(user: dime.createdBy)
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
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
}
