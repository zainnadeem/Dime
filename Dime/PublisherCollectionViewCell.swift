//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit

class PublisherCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var publisherImageView: UIImageView!
    @IBOutlet weak var publisherTitleLabel: UILabel!
    
    var dimeMedia: DimeMedia! {
        didSet {
            self.publisherImageView.image = UIImage(named: dimeMedia.photoURL)
            
            self.layer.cornerRadius = 3.0
            self.layer.masksToBounds = true
        }
    }
}


















