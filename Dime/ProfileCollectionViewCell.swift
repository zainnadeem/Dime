import UIKit
import SAMCache
import OneSignal

class ProfileCollectionViewCell: UICollectionViewCell, UITextViewDelegate {
    
    var blurEffectView: UIVisualEffectView!
    var backgroundLocationImage = UIImageView()
    var imageView = UIButton()
    var circleProfileView = UIButton()
    
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
    var chatButton = UIButton()
    var popularRankButton = UIButton()
    var background: UIImageView = UIImageView()
    
    lazy var friendDiamond   :  UIButton       = UIButton()
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    weak var parentCollectionView = UIViewController()
    
    var collectionView:UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    lazy var isLikedByUser            : Bool          = Bool()
    lazy var isSuperLikedByUser       : Bool          = Bool()
    lazy var canSuperLike             : Bool          = Bool()
    
    let store = DataStore.sharedInstance
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
        
        
        configureCaptionNameLabel()
        configureImageView()
        configureLikeButton()
        configureLikeLabel()
        configureSuperLikeButton()
        configureSuperLikeLabel()
        configureCreatedTimeLabel()
        
        self.backgroundColor = UIColor.clear
        
    }

    
    func updateUI() {

        let mediaImageKey = "\(self.dime.uid)-coverImage"
        
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            
            self.imageView.setImage(image, for: .normal)
            
        }else {
            
            dime.downloadCoverImage(coverPhoto: mediaImageKey, completion: {  [weak self] (image, error)in
                self?.imageView.setImage(image, for: .normal)
                
                self?.cache?.setObject(image, forKey: mediaImageKey)
            })
        }
        
        
        self.imageView.imageView?.contentMode = .scaleAspectFill

        imageView.addTarget(self, action: #selector(showMedia), for: .touchUpInside)
        
        captionLabel.text = dime.caption
        
        likesLabel.text = dime.totalDimeLikes.description
        superLikeLabel.text = dime.totalDimeSuperLikes.description
        
        createdTimeLabel.text = parseDate(dime.createdTime)

        
    }
    
    func showMedia(){
        
        let destinationVC = ViewMediaCollectionViewController()
        destinationVC.passedDime = dime
        self.parentCollectionView?.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    

    
    func configureCaptionNameLabel() {
        contentView.addSubview(captionLabel)
        
        self.captionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.captionLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 175).isActive = true
        self.captionLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.captionLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        
        self.captionLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
        
        captionLabel.textAlignment = .center
        captionLabel.font = UIFont.dimeFontBold(14)
        captionLabel.textColor = UIColor.black
    }
    
    
    func configureImageView() {
        contentView.addSubview(imageView)
        
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.layer.cornerRadius = 8.0
        imageView.clipsToBounds = true
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.topAnchor.constraint(equalTo: self.captionLabel.bottomAnchor).isActive = true
        
        self.imageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
        
        self.imageView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.4).isActive = true
        
        self.imageView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    
    func configureLikeButton(){
        contentView.addSubview(likeButton)
        likeButton.titleLabel?.font = UIFont.dimeFont(13)
        likeButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
        likeButton.addTarget(self, action: #selector(seeLikesTapped), for: .touchUpInside)
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 10).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.black
        
        likesLabel.font = UIFont.dimeFontBold(13)
        
        
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant:2).isActive = true
        self.likesLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeButton(){
        contentView.addSubview(superLikeButton)
        superLikeButton.titleLabel?.font = UIFont.dimeFont(13)
        superLikeButton.setImage(#imageLiteral(resourceName: "topDimesHome"), for: .normal)
        
        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeButton.leadingAnchor.constraint(equalTo: self.likesLabel.trailingAnchor, constant: 10).isActive = true
        self.superLikeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 20).isActive = true
        
        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.06).isActive = true
        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.11).isActive = true
    }
    
    func configureSuperLikeLabel(){
        contentView.addSubview(superLikeLabel)
        superLikeLabel.backgroundColor = UIColor.clear
        superLikeLabel.textAlignment = NSTextAlignment.center
        superLikeLabel.textColor = UIColor.black
        superLikeLabel.font = UIFont.dimeFontBold(13)
        //        superLikeLabel.text = "0"
        
        self.superLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeLabel.leadingAnchor.constraint(equalTo: self.superLikeButton.trailingAnchor, constant:2).isActive = true
        self.superLikeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.superLikeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.superLikeLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureCreatedTimeLabel(){
        contentView.addSubview(createdTimeLabel)
        createdTimeLabel.backgroundColor = UIColor.clear
        createdTimeLabel.textAlignment = NSTextAlignment.right
        createdTimeLabel.textColor = UIColor.black
        createdTimeLabel.font = UIFont.dimeFont(9)
        
        self.createdTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdTimeLabel.leadingAnchor.constraint(equalTo: self.superLikeLabel.trailingAnchor, constant:2).isActive = true
        self.createdTimeLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.createdTimeLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.createdTimeLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -3).isActive = true
        
    }
    
    func seeLikesTapped(){
        let destinationVC = SearchDimeViewController()
        destinationVC.user = store.currentUser
        destinationVC.dime = self.dime
        destinationVC.viewContollerType = SearchViewControllerType.likes
        self.parentCollectionView?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//Hande messaging
fileprivate func parseDate(_ date : String) -> String {
    
    if let timeAgo = (Constants.dateFormatter().date(from: date) as NSDate?)?.timeAgo() {
        return timeAgo
    }
    else { return "" }
}



