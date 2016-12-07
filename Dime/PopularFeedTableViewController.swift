//
//  PopularFeedTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

private let reuseIdentifier = "PopularTableViewCell"

class PopularFeedTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    var passedDimes: [Dime] = [Dime]()
    var viewControllerTitle: UILabel = UILabel()
    var viewControllerIcon: UIButton = UIButton()
    
    lazy var tableView : UITableView = UITableView()
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_YELLOW")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
         self.tableView.register(PopularTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
       
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        setUpTableView()
        configureTitleLabel()
        configureTitleIcon()
        fetchDimes()

    }

    func fetchDimes() {
        self.tableView.reloadData()
        Dime.observeNewDime { (dime) in
            if !self.passedDimes.contains(dime) {
                self.passedDimes.insert(dime, at: 0)
                self.tableView.reloadData()
            }
        }
    }
    
    
    func setUpTableView(){
        self.view.addSubview(self.tableView)
        
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        self.tableView.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 5.0).isActive = true
        self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.tableView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
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
        return passedDimes.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! PopularTableViewCell
        
        cell.setViewConstraints()
        cell.setViewProperties(withDime: passedDimes[indexPath.row])
        return cell
    }

 
}

extension PopularFeedTableViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}
