//
//  CommentsViewController.swift
//
//  Dime
//
//  Created by Zain Nadeem on 12/1/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "CommentTableViewCell"

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITextFieldDelegate {
    
    
    let store = DataStore.sharedInstance
    var media: Media!
    var currentUser: User!
    var comments = [Comment]()
    
    var captionTextView: UITextField = UITextField()
    var postButton: UIButton = UIButton()
    
    
    lazy var tableView : UITableView = UITableView()
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear

        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navBar.delegate = self
        self.captionTextView.delegate = self
        
        self.view.addSubview(navBar)
        
        setUpTextView()
        setUpTableView()
        setUpPostButton()
        
        self.tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
 
    }
    
    // Mark - UITableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return media.comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CommentTableViewCell
        
        cell.setViewConstraints()
        cell.comment = media.comments[indexPath.row]
        cell.backgroundColor = UIColor.clear
        return cell

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.view.bounds.width / 4
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
            // "Shows user profile"
    }
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 5.0).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.captionTextView.topAnchor).isActive = true
        self.tableView.backgroundColor = UIColor.black
        self.tableView.separatorColor = UIColor.white
        tableView.tableFooterView = UIView()
        self.tableView.alpha = 0.85
    }
    
    func setUpTextView(){
        self.view.addSubview(self.captionTextView)
        
        self.captionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.captionTextView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.08).isActive = true

        self.captionTextView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        self.captionTextView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -60).isActive = true
        self.captionTextView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        
        self.captionTextView.layer.borderWidth = 1.0
        self.captionTextView.layer.borderColor = UIColor.white.cgColor
        self.captionTextView.attributedPlaceholder = NSAttributedString(string: "add comment here")
    
        self.captionTextView.textColor = UIColor.white
        self.captionTextView.textAlignment = .center

    }
    
    
    func setUpPostButton(){
        self.view.addSubview(self.postButton)
        
        self.postButton.translatesAutoresizingMaskIntoConstraints = false
        self.postButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.15).isActive = true
        
        self.postButton.leadingAnchor.constraint(equalTo: self.captionTextView.trailingAnchor, constant: 2).isActive = true
        
        self.postButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 2).isActive = true
        self.postButton.centerYAnchor.constraint(equalTo: self.captionTextView.centerYAnchor).isActive = true
        
        self.postButton.setTitle("POST", for: .normal)
        self.postButton.addTarget(self, action:  #selector(postDidTap), for: UIControlEvents.touchUpInside)
    }
    

    
    func postDidTap(){
        let comment = Comment(dimeUID: media.dimeUID, mediaUID: media.uid, from: store.currentUser!, caption:captionTextView.text!)
        comment.save()
        media.comments.append(comment)
        self.tableView.reloadData()
    }
}

    
extension CommentsViewController : NavBarViewDelegate {
        
        func rightBarButtonTapped(_ sender: AnyObject) {
            print("Not sure what the right bar button will do yet.")
        }
        
        func leftBarButtonTapped(_ sender: AnyObject) {
            
            self.dismiss(animated: true, completion: nil)

        }
        
        func middleBarButtonTapped(_ Sender: AnyObject) {
            print("Not sure what the middle bar button will do yet.")
        }
    
    
    
}
