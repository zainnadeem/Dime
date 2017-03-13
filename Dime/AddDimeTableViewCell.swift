//
//  AddDimeTableViewCell.swift
//  
//
//  Created by Lloyd W. Sykes on 3/11/17.
//
//

import UIKit

class AddDimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var topDimeButton: UIButton!
    @IBOutlet weak var starRatingLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var friendButton: UIButton!

    func checkingLayout() {
        profileImageView.backgroundColor = .red
        usernameLabel.backgroundColor = .blue
        topDimeButton.backgroundColor = .yellow
        messageButton.backgroundColor = .green
        friendButton.backgroundColor = .purple
    }
    
}
