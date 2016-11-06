//
//  DimeImageDisplayCollectionViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 11/5/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class DimeImageDisplayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var photoDiamondImage: UIImageView!
    @IBOutlet weak var photoLikeCount: UILabel!
    @IBOutlet weak var totalDiamondImage: UIImageView!
    @IBOutlet weak var totalDimeCount: UILabel!
    @IBOutlet weak var datePostedLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var viewAllCommentsButton: UIButton!
    
    func setCellProperties(withDimeMedia dimeMedia: DimeMedia){
        photoImage.image = UIImage(named: dimeMedia.photoURL)
        photoLikeCount.text = dimeMedia.likes
        datePostedLabel.text = dimeMedia.dateCreated
        captionLabel.text = dimeMedia.caption
 
    }
    
}
