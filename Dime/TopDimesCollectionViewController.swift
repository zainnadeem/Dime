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

private let reuseIdentifier = "dimeCollectionViewCell"

class TopDimesCollectionViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UITextViewDelegate {
    
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerIcon: UIButton = UIButton()
    var topDimesButton = UIButton()
    var addDimeButton = UIButton()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "searchIcon"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))
    
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
        configureTopDimesButton()
        fetchDimes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchDimes()
    }
    
    func configureTitleLabel(){
        self.view.addSubview(self.viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.viewControllerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.viewControllerTitle.backgroundColor = UIColor.darkGray
        self.viewControllerTitle.textAlignment = NSTextAlignment.left
        self.viewControllerTitle.textColor = UIColor.white
        self.viewControllerTitle.font = UIFont.dimeFont(15)
        self.viewControllerTitle.text = "        TOP DIMES"
    }
    
    func configureTitleIcon() {
        self.view.addSubview(viewControllerIcon)
        self.viewControllerIcon.setImage(#imageLiteral(resourceName: "icon-diamond-black"), for: .normal)
        
        self.viewControllerIcon.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.viewControllerIcon.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewControllerIcon.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewControllerIcon.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    func configureTopDimesButton() {
        self.view.addSubview(self.topDimesButton)
        self.view.addSubview(self.addDimeButton)
        self.viewControllerTitle.bringSubview(toFront: self.topDimesButton)
        
        self.addDimeButton.tintColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.addDimeButton.setImage(#imageLiteral(resourceName: "icon-add"), for: .normal)
        
        self.addDimeButton.translatesAutoresizingMaskIntoConstraints = false
        self.addDimeButton.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.addDimeButton.trailingAnchor.constraint(equalTo: self.viewControllerTitle.trailingAnchor, constant: -8).isActive = true
        self.addDimeButton.heightAnchor.constraint(equalToConstant: 24)
        self.addDimeButton.widthAnchor.constraint(equalToConstant: 24)
        
        self.topDimesButton.translatesAutoresizingMaskIntoConstraints = false
        self.topDimesButton.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.topDimesButton.trailingAnchor.constraint(equalTo: self.addDimeButton.leadingAnchor, constant: -8).isActive = true
        
        self.topDimesButton.backgroundColor = .clear
        
        self.topDimesButton.addTarget(self, action: #selector(topDimesButtonTapped), for: .touchUpInside)
        self.addDimeButton.addTarget(self, action: #selector(topDimesButtonTapped), for: .touchUpInside)
        
        if let topDimesCount = self.store.currentUser?.topFriends.count {
            self.topDimesButton.setTitle("\(topDimesCount)", for: .normal)
        }
    }
    
    func topDimesButtonTapped() {
        if let topDimesVC = UIStoryboard(name: "TopDimes", bundle: nil).instantiateInitialViewController() {
            self.present(topDimesVC, animated: true, completion: nil)
        }
    }
    
    func reloadDataToFirstCell(){
        self.dimeCollectionView.reloadData()
        self.dimeCollectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .left, animated: true)
    }
    
    func fetchDimes() {
        self.dimeCollectionView.reloadData()
        
        if let topFriends = store.currentUser?.topFriends{
            for friend in topFriends{
                Dime.observeFriendsDimes(user: friend, { (dime) in
                    
                    if !self.passedDimes.contains(dime) && Constants.isDimeWithinTwoDays(videoDate: dime.createdTime)  {
                        self.passedDimes.insert(dime, at: 0)
                        self.dimeCollectionView.reloadData()
                        
                    }
                })
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
        
        cell.parentCollectionView = self
        cell.collectionView = dimeCollectionView
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
    
    
}

extension TopDimesCollectionViewController : NavBarViewDelegate {
    
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationTableViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        let destinationVC = SearchDimeViewController()
        
        
        if let user = store.currentUser{
            destinationVC.user = user
        }
        
        destinationVC.viewContollerType = SearchViewControllerType.searchAllUsers
        self.navigationController?.pushViewController(destinationVC, animated: true)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension TopDimesCollectionViewController : DZNEmptyDataSetSource {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = #imageLiteral(resourceName: "topDimesHome")
        
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
        let text = "You haven't added any Top Dimes"
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(24.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        
        
        return NSAttributedString(string: text, attributes: attributes)
        
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text = "You can add friends to your top dimes to keep up with your besties. Just hit the diamond located on the top of your friends' stories."
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.alignment = .center
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(14.0),
                          NSForegroundColorAttributeName : UIColor.lightGray,
                          NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.dimeFontBold(18.0),
                          NSForegroundColorAttributeName : UIColor.black]
        
        return NSAttributedString(string: "Add a Top Dime today!👬", attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}


extension TopDimesCollectionViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

