//
//  SignUpTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class SignUpTableViewController: UITableViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    var imagePickerHelper: ImagePickerHelper!
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
                if error != nil {
                    //Report error
                } else if let firUser = firUser {
                    let newUser = User(uid: firUser.uid, username: username, fullName: fullName, bio: "", website: "", follows: [], followedBy: [], profileImage: self.profileImage, dimes: [])
                    newUser.save(completion: { (error) in
                            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                                if let error = error {
                                        print(error.localizedDescription)
                                } else {
                                       self.dismissKeyboard()
                                       self.dismiss(animated: true, completion: {
                                       })
                                }
                            })
                    })
                }
            })
        }

    }
    @IBAction func backDidTap(_ sender: Any) {
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeProfilePhotoDidTap() {
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            self.profileImageView.image = image
            self.profileImage = image!
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

}

