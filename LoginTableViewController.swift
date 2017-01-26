//
//  LoginTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

class LoginTableViewController: UITableViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
      let activityData = ActivityData()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        title = "Log in"
        
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
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
                NVActivityIndicatorPresenter.sharedInstance.startAnimating(self.activityData)
                if let error = error {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.alert(title: "Oops!", message: error.localizedDescription, buttonTitle: "OK")
                }else{
                    self.dismissKeyboard()
                    
                    
                    self.performSegue(withIdentifier: "showHomeViewController", sender: self)
                    
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    

                }
            })
        }else{
            self.alert(title: "Oops!", message: "Please enter a valid email address and password", buttonTitle: "Okay")
        }
 
    }
    
    @IBAction func forgotPasswordDidTap(_ sender: Any) {
        self.sendPasswordResetEmail()

    }
    
    func sendPasswordResetEmail(){

        let alertVC = UIAlertController(title: "No worries", message: "We can reset your password with a few simple steps. Please enter your email address.", preferredStyle: .alert)
        

        
        alertVC.addTextField(configurationHandler: configurationTextField)
        
        let reset = UIAlertAction(title: "reset", style: .default, handler: {
            action in
            
            self.resetPasswordWithEmail((alertVC.textFields?[0].text!)!)
            
        })
       
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(reset)
        alertVC.addAction(cancel)
        present(alertVC, animated: true, completion: nil)
        
    }
    
    func configurationTextField(textField: UITextField!){
        print("generating the TextField")
        textField.placeholder = "Email Address"
    }
    
    func resetPasswordWithEmail(_ email: String){
        FIRAuth.auth()?.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.alert(title: "Sorry", message: "We did not recognize that email address.", buttonTitle: "okay")
            } else {
                self.alert(title: "Success", message: "An email to reset your password has been sent.", buttonTitle: "okay")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showHomeViewController" {
            
            let destinationVC = segue.destination as! TabBarViewController
            destinationVC.selectedIndex = 2
            
            
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
    

