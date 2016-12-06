//
//  PostComposerViewController.swift
//  Moments
//
//  Created by Zain Nadeem on 11/9/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class PostComposerViewController: UITableViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var shareBarButtonItem: UIBarButtonItem!
    
    var image: UIImage!
    var imagePickerSourceType: UIImagePickerControllerSourceType!
    var store = DataStore.sharedInstance
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.becomeFirstResponder()
        textView.text = ""
        textView.delegate = self
        shareBarButtonItem.isEnabled = false
        imageView.image = self.image
        
        tableView.allowsSelection = false

    }
    @IBAction func cancelDidTap() {
        
        self.image = nil
        self.imageView.image = nil
        textView.resignFirstResponder()
        textView.text = ""
        self.dismiss(animated: true, completion: nil)
        
    
    }


//    @IBAction func shareDidTap(_ sender: AnyObject) {
//    
//        if let image = image, let caption = textView.text {
//            if let currentUser = store.currentUser{
//                
//                let newMedia = Media(type: "image", caption: caption, createdBy: currentUser, image: image, location: "")
//                
//                let newDime = Dime(caption: caption, createdBy: currentUser, media: [newMedia])
//                
//                newDime.save(caption: caption, completion: { (error) in
//                    if let error = error {
//                        self.alert(title: "Oops", message: error.localizedDescription, buttonTitle: "OK")
//                    }
//                })
//                
//                newMedia.save(completion: { (error) in
//                    if let error = error {
//                        self.alert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
//                    }else {
//                        currentUser.share(newMedia: newMedia)
//                        currentUser.addToDime(newMedia: newMedia, caption: caption)
//                    }
//                    
//                })
//            }
//            
//        }
//        self.cancelDidTap()
//    }

    
    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }




}

extension PostComposerViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        shareBarButtonItem.isEnabled = textView.text != ""
    
    }
}
