//
//  DimeCollectionViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import DZNEmptyDataSet
import SAMCache

private let reuseIdentifier = "dimeCollectionViewCell"

class ProfileCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    

    var user : User?
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerIcon: UIButton = UIButton()
    var viewAllMessagesButton: UIButton = UIButton()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage:nil, leftButtonImage: #imageLiteral(resourceName: "backArrow"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    
    var dimeCollectionView : UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        
        self.dimeCollectionView.emptyDataSetDelegate = self
        self.dimeCollectionView.emptyDataSetSource = self
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_GREY")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        configureTitleLabel()
        configureTitleIcon()
        configureMessagesIcon()
        showUserSpecificButtons()
        fetchDimes()
        
        
        
        
    }
    
    func showUserSpecificButtons(){
        
        guard let profileUser = self.user else { return }
        if profileUser == self.store.currentUser {
          navBar.rightButton.image = #imageLiteral(resourceName: "icon-settings-filled")
          viewAllMessagesButton.setImage(#imageLiteral(resourceName: "icon-comment"), for: .normal)
         viewAllMessagesButton.imageView?.tintColor = UIColor.white
          navBar.rightButton.isEnabled = true
          viewAllMessagesButton.isEnabled = true
            
        }else{
            navBar.rightButton.image = nil
            viewAllMessagesButton.setImage(nil, for: .normal)
            navBar.rightButton.isEnabled = false
            viewAllMessagesButton.isEnabled = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDimes()
    }
    
    func configureTitleLabel(){
        self.view.addSubview(viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.viewControllerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        viewControllerTitle.backgroundColor = UIColor.darkGray
        viewControllerTitle.textAlignment = NSTextAlignment.left
        viewControllerTitle.textColor = UIColor.white
        viewControllerTitle.font = UIFont.dimeFont(15)
        if let currentUser = self.user{
        viewControllerTitle.text = "        \(currentUser.username)"
        }
    }
    
    func configureTitleIcon() {
        self.view.addSubview(viewControllerIcon)
        viewControllerIcon.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
        
        
        self.viewControllerIcon.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.viewControllerIcon.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewControllerIcon.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewControllerIcon.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureMessagesIcon() {
        self.view.addSubview(viewAllMessagesButton)

        
        self.viewAllMessagesButton.addTarget(self, action: #selector(showChats), for: .touchUpInside)
        self.viewAllMessagesButton.translatesAutoresizingMaskIntoConstraints = false
        self.viewAllMessagesButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        self.viewAllMessagesButton.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewAllMessagesButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewAllMessagesButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
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
        
        cell.parentCollectionView = self
        cell.collectionView = dimeCollectionView
        
        cell.currentUser = store.currentUser
        cell.dime = passedDimes[indexPath.row]
        
        cell.usernameButton.isUserInteractionEnabled = false
        cell.circleProfileView.isUserInteractionEnabled = false
        
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
        dimeCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(dimeCollectionView)
        dimeCollectionView.isPagingEnabled = true
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
        
//        let destinationVC = ViewMediaCollectionViewController()
//        destinationVC.passedDime = passedDimes[indexPath.row]
//        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
   
    
    func showChats(){
        let destinationVC = ChatsTableViewController()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    
}

extension ProfileCollectionViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        let destinationVC = SettingsViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
        
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        self.navigationController?.popViewController(animated: true)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        
        var visibleCurrentCell: IndexPath? {
            for cell in self.dimeCollectionView.visibleCells {
                let indexPath = self.dimeCollectionView.indexPath(for: cell)
                return indexPath
            }
            
            return nil
        }
        guard let currentUserCell = visibleCurrentCell else { return }
        let dime = passedDimes[currentUserCell.row]
        if dime.createdBy != store.currentUser{
            let destinationVC = ProfileCollectionViewController()
            destinationVC.user = store.currentUser
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
    }
    
}

extension ProfileCollectionViewController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = #imageLiteral(resourceName: "topDimesHomeUnfilled")
        
        let size = image.size.applying(CGAffineTransform(scaleX: 0.2, y: 0.2))
        let hasAlpha = true
        let scale : CGFloat = 0.0
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "No Dimes😪"
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(24.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        
        
        return NSAttributedString(string: text, attributes: attributes)
        
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(14.0),
                          NSForegroundColorAttributeName : UIColor.lightGray,
                          NSParagraphStyleAttributeName : paragraph]
        
        
        guard let profileUser = self.user else { return NSAttributedString(string: "No photos or videos", attributes: attributes) }
        
        var text = "\(profileUser.username) has not added any photos or videos."
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.dimeFontBold(18.0),
                          NSForegroundColorAttributeName : UIColor.black]
        
        return NSAttributedString(string: "Check back later!", attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}


extension ProfileCollectionViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
