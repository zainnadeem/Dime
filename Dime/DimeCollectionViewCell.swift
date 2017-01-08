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
    
    weak var parentCollectionView = UIViewController()
    
    lazy var isLikedByUser            : Bool          = Bool()
    lazy var isSuperLikedByUser       : Bool          = Bool()
    lazy var canSuperLike             : Bool          = Bool()
    
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
        
        self.imageView.image = nil
        
        let mediaImageKey = "\(self.dime.media[0].uid)-coverImage"
        
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
        
        circleProfileView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
        
        let profileImageKey = "\(self.dime.createdBy.uid)-profileImage"
        
        if let image = cache?.object(forKey: profileImageKey) as? UIImage {
            self.circleProfileView.image = image.circle
        }else{
            
            dime.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.image = image.circle
                    self?.cache?.setObject(image, forKey: profileImageKey)
                }else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        

         // setImageViewCircular()
        usernameButton.setTitle(dime.createdBy.fullName, for: .normal)
        usernameButton.addTarget(self, action: #selector(usernameButtonPressed), for: .touchUpInside)
        
        
        DimeNameLabel.text = dime.caption
        DimeNameLabel.textColor = UIColor.black
        
        if dime.superLikes.contains(currentUser){
            self.isSuperLikedByUser = true
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
        }else{
            self.isSuperLikedByUser = false
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamondUnfilled"), for: .normal)
        }
        
        if self.didSuperLikeWithinOneDay(superLikeDate: self.currentUser!.lastSuperLikeTime) || isSuperLikedByUser == true{
            canSuperLike = false
            self.superLikeButton.removeTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
            self.superLikeButton.addTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
        }else{
            canSuperLike = true
             self.superLikeButton.removeTarget(self, action: #selector(cantSuperLikeAlert), for: .touchUpInside)
            self.superLikeButton.addTarget(self, action: #selector(superLikeAlert), for: .touchUpInside)
        }

        calculateTotalLikes()
        reloadLabels()
   
    }
    
    
    
    func calculateTotalLikes(){
        var totalLikes = 0
        for media in dime.media{
             totalLikes += media.likes.count
        }
        likesLabel.text = totalLikes.description
    }

    func usernameButtonPressed() {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = dime.createdBy
        self.parentCollectionView?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func configureProfilePic() {
        contentView.addSubview(circleProfileView)
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 130).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20).isActive = true

        self.circleProfileView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.04).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.07).isActive = true
    }

    func configureDimeNameLabel() {
        contentView.addSubview(DimeNameLabel)
        
        self.DimeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.DimeNameLabel.bottomAnchor.constraint(equalTo: self.imageView.topAnchor, constant: -7).isActive = true
        
        self.DimeNameLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor).isActive = true
        
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
        likeButton.titleLabel?.font = UIFont.dimeFont(16)
        likeButton.setImage(#imageLiteral(resourceName: "icon-blueDiamond"), for: .normal)
        
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 5).isActive = true
        self.likeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5).isActive = true
        
        self.likeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        self.likeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.09).isActive = true
    }
    
    func configureLikeLabel(){
        contentView.addSubview(likesLabel)
        likesLabel.backgroundColor = UIColor.clear
        
        likesLabel.textAlignment = NSTextAlignment.center
        likesLabel.textColor = UIColor.black
        
        likesLabel.font = UIFont.dimeFont(9)
        
        
        self.likesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.likesLabel.leadingAnchor.constraint(equalTo: self.likeButton.trailingAnchor, constant:2).isActive = true
        self.likesLabel.centerYAnchor.constraint(equalTo: self.likeButton.centerYAnchor).isActive = true
        self.likesLabel.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.03).isActive = true
        self.likesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureSuperLikeButton(){
        contentView.addSubview(superLikeButton)
        superLikeButton.titleLabel?.font = UIFont.dimeFont(16)
        

        
        self.superLikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.superLikeButton.leadingAnchor.constraint(equalTo: self.likesLabel.trailingAnchor, constant: 5).isActive = true
        self.superLikeButton.topAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: 5).isActive = true
        
        self.superLikeButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.07).isActive = true
        self.superLikeButton.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.09).isActive = true
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
    
    func setImageViewCircular() {
        self.circleProfileView.contentMode = .scaleAspectFill
        self.circleProfileView.isUserInteractionEnabled = true
        self.circleProfileView.layer.cornerRadius = self.frame.height * profileImageHeightMultiplier / 2
        self.circleProfileView.layer.borderColor = UIColor.black.cgColor
        self.circleProfileView.layer.borderWidth = borderWidth
        self.circleProfileView.clipsToBounds = true
    }


}

// button
extension DimeCollectionViewCell {

    func superLikeUnLikeButtonTapped() {
        if isSuperLikedByUser{
            dime.unSuperLikedBy(user: currentUser)
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
            dimeRef.setValue(nil)
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamondUnfilled"), for: .normal)
            isSuperLikedByUser = false
        }else{
            dime.superLikedBy(user: currentUser)
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
            dimeRef.setValue(currentUser.toDictionary())
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-blackDiamond"), for: .normal)
            isSuperLikedByUser = true
        }
        reloadLabels()
    }
    
    
    func reloadLabels(){
        if dime.superLikes != [] {
            superLikeLabel.text = dime.superLikes.count.description
        }else{
            superLikeLabel.text = "0"
        }
    }
    
    func didSuperLikeWithinOneDay(superLikeDate date : String) -> Bool {
        if let creationDate = Constants.dateFormatter().date(from: date) {
            
            let yesterday = Constants.dateFormatter().date(from: Constants.oneDayAgo())!
            
            if creationDate.compare(yesterday) == .orderedDescending { return true }
            else if creationDate.compare(yesterday) == .orderedSame  { return true }
            else { return false }
            
        } else {
            print("Couldn't get NSDate object from string date arguement")
            return false
        }
    }

    func superLikeAlert() {
        let alertVC = UIAlertController(title: "SuperLiked!", message: "You can only super like one dime every 24 hours, you cannot undo this action, is this your superlike today?", preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.currentUser.superLikeDime()
            self.superLikeUnLikeButtonTapped()
            self.canSuperLike = false
            self.updateUI()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
       
        
        alertVC.addAction(yesAction)
        alertVC.addAction(cancelAction)
        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
    }
    
    func cantSuperLikeAlert() {
        var message = ""
        if isSuperLikedByUser { message = "You've already superliked this one!"}else{ message = "You've already superliked today!"
        }
        
        let alertVC = UIAlertController(title: "Sorry", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        
        alertVC.addAction(cancelAction)
        self.parentCollectionView?.present(alertVC, animated: true, completion: nil)
    }

}









