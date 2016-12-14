import UIKit
import Firebase
import SAMCache


class PopularTableViewCell: UITableViewCell {

    lazy var profileImage           : UIImageView   = UIImageView()
    
    lazy var mainLabelStackview     : UIStackView   = UIStackView()
    lazy var fullName               : UILabel       = UILabel()
    lazy var tagsLabel              : UILabel       = UILabel()
    lazy var timeAgoLabel           : UILabel       = UILabel()
    lazy var averageLikesLabel      : UILabel       = UILabel()
    
    lazy var rightLabelStackview    : UIStackView   = UIStackView()
    
    lazy var distanceStack          : UIStackView   = UIStackView()
    lazy var distanceLabel          : UILabel       = UILabel()
    lazy var distanceIcon           : UIImageView   = UIImageView()
    
    lazy var roarsStack             : UIStackView   = UIStackView()
    lazy var roarsCountLabel        : UILabel       = UILabel()
    lazy var roarsIcon              : UIImageView   = UIImageView()
    
    lazy var dealsStack             : UIStackView   = UIStackView()
    lazy var dealCountLabel         : UILabel       = UILabel()
    lazy var dealsIcon              : UIImageView   = UIImageView()
    
    lazy var iconsStack             : UIStackView   = UIStackView()
    lazy var textLabelsStack        : UIStackView   = UIStackView()

    
    lazy var activitySpinner        : UIActivityIndicatorView
        = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    lazy var borderWidth            : CGFloat       = 3.0
    lazy var profileImageHeightMultiplier : CGFloat =      (0.75)
    
    lazy var orangeSideBar          : UIView        = UIView(frame: CGRect(x: 0, y: 0, width: 7.5, height: self.contentView.bounds.height))
    
    var currentUser: User!
    var dime: Dime! {
        didSet{
            if currentUser != nil {
                self.setViewProperties()
            }
        }
    }
    
    var cache = SAMCache.shared()
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            self.orangeSideBar.backgroundColor = UIColor.dimeLightBlue()
            self.profileImage.layer.borderColor = UIColor.dimeLightRed().cgColor
        }
        else {
            self.orangeSideBar.backgroundColor = UIColor.clear
            self.profileImage.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setViewConstraints() {
        
        
        self.profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        self.mainLabelStackview.translatesAutoresizingMaskIntoConstraints = false
        self.fullName.translatesAutoresizingMaskIntoConstraints = false
        self.tagsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.timeAgoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.averageLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
        self.mainLabelStackview.addArrangedSubview(self.tagsLabel)
        self.mainLabelStackview.addArrangedSubview(self.timeAgoLabel)
        
        self.contentView.addSubview(self.orangeSideBar)
        self.orangeSideBar.backgroundColor = UIColor.clear
        
        
        
        self.contentView.addSubview(self.averageLikesLabel)
        self.averageLikesLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        self.averageLikesLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 2).isActive = true
        self.averageLikesLabel.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2).isActive = true
        self.averageLikesLabel.heightAnchor.constraint(equalTo: self.fullName.heightAnchor).isActive = true
        self.averageLikesLabel.text = "55"
        
        
    }
    
    
    
    func setViewProperties() {
        
        //timeAgoLabel.text = dime.createdTime.description
        
        if let image = cache?.object(forKey: "\(self.dime.createdBy.uid)-profileImage") as? UIImage {
            self.profileImage.image = image
        }else{
            
            dime.createdBy.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.profileImage.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.dime.createdBy.uid)-profileImage")
                }else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        

        //self.profileImage.image = nil
        self.profileImage.contentMode = .scaleAspectFill
        self.profileImage.layer.cornerRadius = self.profileImage.frame.width / 2
        self.profileImage.layer.borderWidth = borderWidth
        self.profileImage.layer.borderColor = UIColor.white.cgColor
        self.profileImage.clipsToBounds = true
        

        self.setImageViewCircular()
        self.fullName.textColor = UIColor.black
        self.fullName.font = UIFont.dimeFont(18)
        self.fullName.text = dime.createdBy.fullName
        
//        self.tagsLabel.font = UIFont.manestreamFont(15)
//        self.tagsLabel.textColor = UIColor.darkGray
//        self.tagsLabel.text = business.locationText
        
        self.timeAgoLabel.font = UIFont.dimeFont(12)
        self.timeAgoLabel.textColor = UIColor.lightGray
        
        if dime.likes == [] {
            self.averageLikesLabel.text = "0"
        }else{
            self.averageLikesLabel.text = dime.likes.count.description
        }
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
