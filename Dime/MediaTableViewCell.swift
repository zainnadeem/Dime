//
//  MediaTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 11/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class MediaTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mediaImage: UIImageView!
    @IBOutlet weak var viewMediaButton: UIButton!
    @IBOutlet weak var numberOfLikesLabel: UIButton!
    
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var viewCommentsButton: UIButton!
    @IBOutlet weak var timePostedLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellProperties(withDimeMedia dimeMedia: DimeMedia){
        
        mediaImage.image = UIImage(named: (dimeMedia.photoURL))
        numberOfLikesLabel.titleLabel?.text = dimeMedia.likes
        captionLabel.text = dimeMedia.caption
        timePostedLabel.text = dimeMedia.dateCreated
        
    }



}
