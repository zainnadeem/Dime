//
//  AddDimeTableViewCell.swift
//
//
//  Created by Lloyd W. Sykes on 3/11/17.
//
//

import UIKit

class AddDimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var starRatingButton: UIButton!
    @IBOutlet weak var topDimeButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!
    
    func updateUI() {
        
        usernameLabel.font = UIFont.dimeFontBold(30)
        starRatingButton.setImage(#imageLiteral(resourceName: "icon-popular"), for: .normal)
        topDimeButton.setImage(#imageLiteral(resourceName: "topDimesHomeUnfilled"), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "icon-chatBlack"), for: .normal)
        friendButton.setImage(#imageLiteral(resourceName: "friendsHome"), for: .normal)
    }
    
    
}
