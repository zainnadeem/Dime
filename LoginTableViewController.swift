//
//  LoginTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        title = "Log in"
        
        emailTextField.becomeFirstResponder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        

    }

    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    
    @IBAction func backDidTap(_ sender: AnyObject) {
        self.dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginDidTap() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        
        if emailTextField.text != ""
            && (passwordTextField.text?.characters.count)! > 6 {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (firUser, error) in
                if let error = error {
                    self.alert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
                }else{
                    self.dismissKeyboard()
                    self.dismiss(animated: true, completion: nil)
                }
            })
        }
        
        
        
    }
}
    extension LoginTableViewController: UITextFieldDelegate {
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if textField == emailTextField{
                passwordTextField.becomeFirstResponder()
            }else if textField == passwordTextField{
                passwordTextField.resignFirstResponder()
                loginDidTap()
            }
            return true
        }
        
        func dismissKeyboard() {
            //Causes the view (or one of its embedded text fields) to resign the first responder status.
            view.endEditing(true)
        }
    }
    

