//
//  CommentComposerViewController.swift
//  Moments
//
//  Created by Zain Nadeem on 11/16/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class CommentComposerViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UIButton!

    @IBOutlet weak var captionTextView: UITextView!
    @IBOutlet weak var postBarButtonItem: UIBarButtonItem!
    
    var currentUser: User!
    var media: Media!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = postBarButtonItem
        navigationItem.title = "Share new comment"
        
        postBarButtonItem.isEnabled = false
        captionTextView.text = ""
        captionTextView.becomeFirstResponder()
        captionTextView.delegate = self
        
        if currentUser.profileImage == nil{
            profileImageView.image = #imageLiteral(resourceName: "icon-defaultAvatar")
            currentUser.downloadProfilePicture(completion: { (image, error) in
                self.profileImageView.image = image
            })
        } else {
            profileImageView.image = currentUser.profileImage
        }
        
        usernameLabel.setTitle(currentUser.username, for: [])
    }

    
//    @IBAction func postDidTap(){
//        let comment = Comment(mediaUID: media.uid, from: currentUser, caption: captionTextView.text)
//        comment.save()
//        media.comments.append(comment)
//        self.navigationController?.popViewController(animated: true)
//    }
    
}

extension CommentComposerViewController : UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" {
            postBarButtonItem.isEnabled = false
        } else{
            postBarButtonItem.isEnabled = true
        }
    }
}
