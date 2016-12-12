//
//  DimeCollectionViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import SAMCache

private let reuseIdentifier = "profileCollectionViewCell"

class ProfileCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    
    let store = DataStore.sharedInstance
    var user : User?
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerBanner: UIView = UIView()
    var circleProfileView: UIImageView = UIImageView()
    var cache = SAMCache.shared()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))
    
    var dimeCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_GREY")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        configurerBanner()
        configureProfilePic()
        configureTitleLabel()
       
        fetchDimes()
        
    }
    
    
    func configureProfilePic() {
        self.view.addSubview(circleProfileView)
        
        if let image = cache?.object(forKey: "\(user?.uid)-profileImage") as? UIImage {
            self.circleProfileView.image = image
        }else{
            user?.downloadProfilePicture { [weak self] (image, error) in
                if let image = image {
                    self?.circleProfileView.image = image
                    self?.cache?.setObject(image, forKey: "\(self?.user?.uid)- profileImage")
                }else if error != nil {
                    print(error?.localizedDescription)
                }
            }
        }
        
        circleProfileView.layer.cornerRadius = circleProfileView.bounds.width / 2.0
        circleProfileView.layer.masksToBounds = true
        
        self.circleProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.circleProfileView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 85).isActive = true
        self.circleProfileView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
        
        self.circleProfileView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.11).isActive = true
        
        self.circleProfileView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.20).isActive = true
    }
    
    
    func configureTitleLabel(){
        self.view.addSubview(viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.viewControllerBanner.topAnchor, constant: 5).isActive = true
        
        self.viewControllerTitle.leadingAnchor.constraint(equalTo: self.viewControllerBanner.leadingAnchor, constant: 10).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.viewControllerBanner.heightAnchor, multiplier: 0.5).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        viewControllerTitle.textAlignment = NSTextAlignment.left
        viewControllerTitle.textColor = UIColor.white

        viewControllerTitle.font = UIFont.dimeFont(30)
        viewControllerTitle.text = user?.fullName
        
    }
    
    func configurerBanner() {
        self.view.addSubview(viewControllerBanner)
        viewControllerBanner.backgroundColor = UIColor.dimeLightBlue()
        
        
        self.viewControllerBanner.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerBanner.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.viewControllerBanner.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 20).isActive = true
        self.viewControllerBanner.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        self.viewControllerBanner.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.74).isActive = true
    }
    
 
    
    func fetchDimes() {
        self.dimeCollectionView.reloadData()
        Dime.observeNewDimeForUser(user: user!, { (dime) in
            if !self.passedDimes.contains(dime) {
                self.passedDimes.insert(dime, at: 0)
                self.dimeCollectionView.reloadData()
            
            }  
        })
    }
    
        
//        Dime.observeNewDimeForUser{ (dime) in
//            if !self.passedDimes.contains(dime) {
//                self.passedDimes.insert(dime, at: 0)
//                self.dimeCollectionView.reloadData()
//            }
//        }
//    }
//    
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return passedDimes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ProfileCollectionViewCell
        cell.currentUser = store.currentUser
        cell.dime = passedDimes[indexPath.row]
        
        return cell
    }
    
    
    
    func setUpCollectionView(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = UICollectionViewScrollDirection.horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        dimeCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        dimeCollectionView.dataSource = self
        dimeCollectionView.delegate = self
        self.dimeCollectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        dimeCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(dimeCollectionView)
        
        //dimeCollectionView.isPagingEnabled = true
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = self.view
            .bounds.size.width
        let collectionViewHeight = self.view
            .bounds.size.height
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //show mediaCollection
        
        let destinationVC = ViewMediaCollectionViewController()
        destinationVC.passedDime = passedDimes[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}

extension ProfileCollectionViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}
