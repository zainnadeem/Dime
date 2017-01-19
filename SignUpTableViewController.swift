//
//  SignUpTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView
import UIKit
import OneSignal

class SignUpTableViewController: UITableViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let activityData = ActivityData()
    
    
    var mediaPickerHelper: MediaPickerHelper!
    var profileImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        
        title = "Create New Account"
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2.0
        //profileImageView.layer.maskToBounds = true
        
        emailTextField.delegate = self
        fullNameTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    @IBAction func createNewAccountDidTap() {
        
        //create a new account
        //save the user data, take a photo
        //log in user
        
        if emailTextField.text != ""
            && (passwordTextField.text?.characters.count)! > 6
            && (usernameTextField.text?.characters.count)! > 6
            && fullNameTextField.text != ""
            && profileImage != nil{
            
            let username = usernameTextField.text!
            let fullName = fullNameTextField.text!
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (firUser, error) in
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                
                if error != nil {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.alert(title: "Oops", message: (error?.localizedDescription)!, buttonTitle: "Okay")
                
                } else if let firUser = firUser {
                   
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", friends: [], topFriends: [], profileImage: self.profileImage, dimes: [], notifications: [], totalLikes: 0, averageLikesCount: 0, mediaCount: 0, popularRank: 0)
                    
                    newUser.save(completion: { (error) in
                        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                            if let error = error {
                                print(error.localizedDescription)
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                self.alert(title: "Oops", message: (error.localizedDescription), buttonTitle: "Okay")
                            } else {
                                self.registerOneSignalToken(user: newUser)
                                self.dismissKeyboard()
                                self.dismiss(animated: true, completion: {
                                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                })
                            }
                        })
                    })
                }
            })
        }else{
            self.alert(title: "Please fill in all fields", message: "Password/username fields must contain more than 6 characters and a profile picture is required", buttonTitle: "Got it")
        }
        
        
        
    }
    @IBAction func backDidTap(_ sender: Any) {
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePhotoDidTap() {
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (image) in
            
            if image != nil{
            let profilePicture = image!
            self.profileImageView.image = (profilePicture as! UIImage).rounded
            self.profileImageView.image = (profilePicture as! UIImage).circle
            
            self.profileImage = (profilePicture as! UIImage).rounded
            self.profileImage = (profilePicture as! UIImage).circle
            }
        })
    }
    
    
    
}

extension SignUpTableViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            fullNameTextField.becomeFirstResponder()
        } else if textField == fullNameTextField {
            usernameTextField.becomeFirstResponder()
        } else if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            passwordTextField.resignFirstResponder()
            createNewAccountDidTap()
        }
        return true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    func registerOneSignalToken(user: User){
        
        OneSignal.idsAvailable({ (userID, pushToken) in
            if userID != nil {
                if !(user.deviceTokens.contains(userID!)){
                    user.deviceTokens.append(userID!)
                    DatabaseReference.users(uid: user.uid).reference().child("deviceTokens").setValue(user.deviceTokens)
                    
                }
                
            }
        })
    }
    
}

