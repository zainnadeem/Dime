//
//  DimeCollectionViewCell.swift
//
//  Zain Nadeem
//  Copyright © 2016 Developers Academy. All rights reserved.
//

import UIKit

class DimeCollectionViewCell: UICollectionViewCell
{
    @IBOutlet weak var publisherImageView: UIImageView!
    @IBOutlet weak var publisherTitleLabel: UILabel!
    
    var media: Media! {
        didSet {
            self.publisherImageView.image = media.mediaImage
            publisherTitleLabel.text = media.caption
            
            self.layer.cornerRadius = 3.0
            self.layer.masksToBounds = true
        }
    }
}


















