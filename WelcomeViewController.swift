 //
//  WelcomeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {
    
    var store = DataStore.sharedInstance
    var signUpButton = UIButton()
    var loginButton = UIButton()
    var dimeIcon = UIImageView()
    var dimeLabel = UILabel()
    var versionLabel = UILabel()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        setUpLoginButton()
        setUpSignUpButton()
        setUpIcon()
        setUpLabel()
        setUpVersionLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setUpIcon(){
        self.view.addSubview(dimeIcon)
        self.dimeIcon.translatesAutoresizingMaskIntoConstraints = false
        self.dimeIcon.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 35).isActive
            = true
        self.dimeIcon.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
        self.dimeIcon.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        
        self.dimeIcon.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.21).isActive = true
        self.dimeIcon.image = #imageLiteral(resourceName: "dimeLogoB&W")
        self.dimeIcon.contentMode = .scaleAspectFit
        self.dimeIcon.layer.shadowColor = UIColor.white.cgColor
        
    }
    
    func setUpLabel(){
        self.view.addSubview(dimeLabel)
        self.dimeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dimeLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive
            = true
        self.dimeLabel.topAnchor.constraint(equalTo: self.dimeIcon.bottomAnchor, constant: 150).isActive = true
        self.dimeLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true
        
        self.dimeLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        self.dimeLabel.textColor = UIColor.white
        self.dimeLabel.font = UIFont.dimeFontBold(45)
        self.dimeLabel.textAlignment = .center
        self.dimeLabel.text = "DIME"
        
    }
    
    func setUpVersionLabel(){
        self.view.addSubview(versionLabel)
        self.versionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.versionLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive
            = true
        self.versionLabel.topAnchor.constraint(equalTo: self.dimeLabel.bottomAnchor, constant: 2).isActive = true
        self.versionLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        
        self.versionLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        self.versionLabel.textColor = UIColor.white
        self.versionLabel.font = UIFont.dimeFont(14)
        self.versionLabel.textAlignment = .center
        self.versionLabel.text = "v1.0.0"
        
    }
    
    
    func setUpLoginButton(){
        self.view.addSubview(loginButton)
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive
            = true
        self.loginButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.loginButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        self.loginButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        self.loginButton.backgroundColor = UIColor.black
        self.loginButton.setTitle("Log in", for: UIControlState())
        self.loginButton.titleLabel?.font = UIFont.dimeFontBold(14)
        self.loginButton.titleLabel?.textColor = UIColor.white
        
        self.loginButton.addTarget(self, action: #selector(self.goToLoginViewController), for: .touchUpInside)
        
    }
    
    func goToLoginViewController(){
        
        self.performSegue(withIdentifier: "showLogin", sender: self)
        
    }
    
    
    func setUpSignUpButton(){
        self.view.addSubview(signUpButton)
        self.signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.signUpButton.bottomAnchor.constraint(equalTo: self.loginButton.topAnchor, constant: 5).isActive
            = true
        self.signUpButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.signUpButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        
        self.signUpButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        self.signUpButton.backgroundColor = UIColor.white
        self.signUpButton.setTitle("Sign up", for: UIControlState())
        self.signUpButton.titleLabel?.font = UIFont.dimeFontBold(14)
        self.signUpButton.setTitleColor(UIColor.black, for: UIControlState())
        signUpButton.layer.cornerRadius = 10
        
        
        self.signUpButton.addTarget(self, action: #selector(self.goToSignUpViewController), for: .touchUpInside)
        
    }
    
    func goToSignUpViewController(){
        
        performSegue(withIdentifier: "showSignUp", sender:self)
    }
    
    
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
}
