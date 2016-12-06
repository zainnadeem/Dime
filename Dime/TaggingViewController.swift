//
//  TaggingViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 12/2/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class TaggingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let store = DataStore.sharedInstance
    var passedMedia: Media?
    var media: Media?
    var editViewController = EditingViewController()
    
    @IBOutlet weak var mediaImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        media = passedMedia
        mediaImageView.image = media?.mediaImage
    }
    
   func hideButtons() {
        self.cancelButton.title = ""
        self.doneButton.title = ""
    }
    
    func unhideButtons() {
        self.cancelButton.title = "Cancel"
        self.doneButton.title = "Done"
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        self.editViewController.dime?.media[editViewController.currentImageNumber - 1] = self.media!
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func imageTapped(_ sender: Any) {
        
        self.performSegue(withIdentifier: "ShowSearchUserController", sender: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSearchUserController"{
            
            let destinationVC = segue.destination as! SearchUserViewController
            destinationVC.modalPresentationStyle = .overCurrentContext
            destinationVC.taggingViewController = self
            if let user = store.currentUser{
                destinationVC.userForView = user }
        }
    }


//Mark: - UITableView
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = media?.usersTagged.count {
                return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.searchUserCell, for: indexPath) as! SearchUserTableViewCell
        
        if let users = media?.usersTagged {
        cell.updateUI(user: users[indexPath.row])
        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            media?.usersTagged.remove(at: indexPath.row)
            self.tableView.reloadData()
        }
    }
        
}
