//
//  PopularFeedTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

private let reuseIdentifier = "PopularTableViewCell"

class PopularFeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    var usersFriends: [User] = [User]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerIcon: UIButton = UIButton()
    var refreshControl: UIRefreshControl!
    
    lazy var tableView : UITableView = UITableView()
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "iconFeed"), leftButtonImage: #imageLiteral(resourceName: "searchIcon"), middleButtonImage: #imageLiteral(resourceName: "menuDime"))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_YELLOW")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
         self.tableView.register(PopularTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
       
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        configureTitleLabel()
        configureTitleIcon()
        setUpTableView()
        
        self.tableView.emptyDataSetDelegate = self
        self.tableView.emptyDataSetSource = self
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        //tableView.addSubview(refreshControl)
        tableView.contentInset = UIEdgeInsetsMake(0, 0, self.bottomLayoutGuide.length, 0)

        fetchUsers()

    }

    func refresh(){

    }

    func fetchUsers() {
        self.tableView.reloadData()
        if let friends = store.currentUser?.friends{
            for friend in friends{
                    if !self.usersFriends.contains(friend) {
                        self.usersFriends.insert(friend, at: 0)
                        if !usersFriends.contains(self.store.currentUser!){usersFriends.append(self.store.currentUser!)}
                        if usersFriends.count == 1 { usersFriends.remove(at: 0)}
                        self.usersFriends = sortByAverageLikes(self.usersFriends)
                        self.tableView.reloadData()
                    }
                }
            }
        }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.loadViewIfNeeded()
        guard let currentUser = self.store.currentUser else { return }
        self.usersFriends = sortByAverageLikes(currentUser.friends)
        fetchUsers()

    }
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.viewControllerTitle.bottomAnchor, constant: 5.0).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -tabBarHeight).isActive = true
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.separatorColor = UIColor.black
        
        
        tableView.tableFooterView = UIView()
        
    }
    
    
    func configureTitleLabel(){
        self.view.addSubview(viewControllerTitle)
        
        self.viewControllerTitle.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerTitle.topAnchor.constraint(equalTo: self.navBar.bottomAnchor).isActive = true
        
        self.viewControllerTitle.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        
        self.viewControllerTitle.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        self.viewControllerTitle.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        viewControllerTitle.backgroundColor = UIColor.dimeLightYellow()
        viewControllerTitle.textAlignment = NSTextAlignment.left
        viewControllerTitle.textColor = UIColor.white
        viewControllerTitle.font = UIFont.dimeFont(15)
        viewControllerTitle.text = "        POPULAR"
        
    }
    
    func configureTitleIcon() {
        self.view.addSubview(viewControllerIcon)
        viewControllerIcon.setImage(#imageLiteral(resourceName: "bar-icon-popular-yellow"), for: .normal)
        
        
        self.viewControllerIcon.translatesAutoresizingMaskIntoConstraints = false
        self.viewControllerIcon.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5).isActive = true
        self.viewControllerIcon.centerYAnchor.constraint(equalTo: self.viewControllerTitle.centerYAnchor).isActive = true
        self.viewControllerIcon.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.03).isActive = true
        self.viewControllerIcon.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.05).isActive = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

     func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usersFriends.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopularTableViewCell
        cell.backgroundColor = UIColor.clear
        cell.setViewConstraints()
        cell.updateUI(user: usersFriends[indexPath.row])
        
        if usersFriends[indexPath.row] == self.store.currentUser{
            cell.poularRank.text = self.store.currentUser?.averageLikesCount.description
            cell.poularRank.textColor = UIColor.white
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  self.view.bounds.width / 4
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = usersFriends[indexPath.row]
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
 
}

extension PopularFeedTableViewController : NavBarViewDelegate {
    
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
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        let destinationVC = ProfileCollectionViewController()
        destinationVC.user = store.currentUser
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
}

extension PopularFeedTableViewController : DZNEmptyDataSetSource {
    
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView!) -> CGFloat {
        return  -80
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        let image = #imageLiteral(resourceName: "popularHome")
        
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
        let text = "The Popular Page"
        
        let attributes = [NSFontAttributeName : UIFont.dimeFont(24.0),
                          NSForegroundColorAttributeName : UIColor.darkGray]
        
        
        return NSAttributedString(string: text, attributes: attributes)
        
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        var text = "This is where stars are born. See which one of your friends gets the most likes per post."
        
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
        
        return NSAttributedString(string: "Let the games begin!🎖", attributes: attributes)
    }
    
    func backgroundColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.white
    }
}


extension PopularFeedTableViewController : DZNEmptyDataSetDelegate {
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return false
    }
}

