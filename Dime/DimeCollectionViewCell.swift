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
            self.circleProfileView.image = image.circle
        }else{
            
            dime.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.image = image.circle
                    self?.cache?.setObject(image, forKey: "\(self?.dime.createdBy.uid)- profileImage")
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
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
        }else{
            self.isSuperLikedByUser = false
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black2"), for: .normal)
        }
        
        if dime.likes.contains(currentUser){
            self.isLikedByUser = true
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue"), for: .normal)
        }else{
            self.isLikedByUser = false
            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue2"), for: .normal)
        }
        
        reloadLabels()
   
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
        self.likeButton.addTarget(self, action: #selector(likeUnLikeButtonTapped), for: .touchUpInside)
        
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
        superLikeButton.titleLabel?.font = UIFont.dimeFont(16)
        self.superLikeButton.addTarget(self, action: #selector(superLikeUnLikeButtonTapped), for: .touchUpInside)
        
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
    
    func likeUnLikeButtonTapped() {
        
        if isLikedByUser{
            dime.unlikedBy(user: currentUser)
            
            //find place for updating user
            
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/likes/\(currentUser.uid)")
            dimeRef.setValue(nil)

            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue2"), for: .normal)
            isLikedByUser = false
        }else{
            dime.likedBy(user: currentUser)
            
            //find place for updating user
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/likes/\(currentUser.uid)")
            dimeRef.setValue(currentUser.toDictionary())

            likeButton.setImage(#imageLiteral(resourceName: "icon-diamond-blue"), for: .normal)
            isLikedByUser = true
        }
        reloadLabels()
    }
    
    func superLikeUnLikeButtonTapped() {
        
        if isSuperLikedByUser{
            dime.unSuperLikedBy(user: currentUser)
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
            dimeRef.setValue(nil)
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black2"), for: .normal)
            isSuperLikedByUser = false
        }else{
            dime.superLikedBy(user: currentUser)
            let dimeRef = DatabaseReference.users(uid: dime.createdBy.uid).reference().child("dimes/\(dime.uid)/superLikes/\(currentUser.uid)")
            dimeRef.setValue(currentUser.toDictionary())
            superLikeButton.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
            isSuperLikedByUser = true
        }
        reloadLabels()
    }
    
    func reloadLabels(){
        if dime.likes != [] {
            likesLabel.text = dime.likes.count.description
        }else{
            likesLabel.text = "0"
        }
        
        if dime.superLikes != [] {
            superLikeLabel.text = dime.superLikes.count.description
        }else{
            superLikeLabel.text = "0"
        }
    }
    
    
}









