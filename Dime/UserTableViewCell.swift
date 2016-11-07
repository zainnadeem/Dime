//
//  UserTableViewCell.swift
//  Dime
//
//  Created by Zain Nadeem on 11/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameLabel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //should be with user
    func setCellProperties(){
        
        profileImage.image = UIImage(named: "t8")
        usernameLabel.titleLabel?.text = "Benny Boy"
        
    }


}
