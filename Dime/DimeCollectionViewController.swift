//
//  DimeCollectionViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "dimeCollectionViewCell"

class DimeCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))
    
    var dimeCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        configureTitleLabel()
        fetchDimes()
    }

    func configureTitleLabel(){
        self.view.addSubview(viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.viewControllerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        viewControllerTitle.backgroundColor = UIColor.lightGray
        viewControllerTitle.textAlignment = NSTextAlignment.center
        viewControllerTitle.textColor = UIColor.white
        viewControllerTitle.font = UIFont.dimeFont(15)
        viewControllerTitle.text = "Top Dimes"
        
    }
    
    func fetchDimes() {
        self.dimeCollectionView.reloadData()
        Dime.observeNewDime { (dime) in
            if !self.passedDimes.contains(dime) {
                self.passedDimes.insert(dime, at: 0)
                self.dimeCollectionView.reloadData()
            }
        }
    }


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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DimeCollectionViewCell
    
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
        self.dimeCollectionView.register(DimeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        dimeCollectionView.backgroundColor = UIColor.black
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
    

    
    
}

extension DimeCollectionViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        try! FIRAuth.auth()?.signOut()
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}
