//
//  NewsFeedTableViewController.swift
//  Moments
//
//  Created by Zain Nadeem on 11/7/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

public struct Storyboard {
    static let showWelcome = "ShowWelcomeViewController"
    static let postComposerNVC = "PostComposerNavigationVC"
    
    static let mediaCell = "MediaCell"
    static let mediaHeaderCell = "MediaHeaderCell"
    static let mediaHeaderHeight: CGFloat = 57
    static let mediaCellDefaultHeight: CGFloat = 597
    
    static let showMediaDetailSegue = "ShowMediaDetailSegue"
    
    static let commentCell = "CommentCell"
    static let showCommentComposer = "ShowCommentComposer"
    static let showHomeSegue = "ShowHomeViewController"
    
}

class NewsFeedTableViewController: UITableViewController {

    var imagePickerHelper: ImagePickerHelper!
    var currentUser: User?
    var media = [Media]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // is the user logged in or not
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            if let user = user {
                // get current user 
                DatabaseReference.users(uid: user.uid).reference().observeSingleEvent(of: .value, with: { (snapshot) in
                    if let userDict = snapshot.value as? [String : Any] {
                        self.currentUser = User(dictionary: userDict)
                       
                        
                    }
                })
                
            }else {

            }
        })
     
        self.tabBarController?.delegate = self
        
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorColor = UIColor.clear
        
        fetchMedia()
        
    }

    @IBAction func homeButtonDidTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func fetchMedia() {
        self.tableView.reloadData()
        Media.observeNewMedia { (media) in
            if !self.media.contains(media) {
                self.media.insert(media, at: 0)
                self.tableView.reloadData()
            }
        }
    }
 

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showMediaDetailSegue {
            let mediaDetailTVC = segue.destination as! MediaDetailTableViewController
            if let selectedIndex = tableView.indexPathForSelectedRow {
                mediaDetailTVC.currentUser = currentUser
                mediaDetailTVC.media = media[selectedIndex.section]
            }
        } else if segue.identifier == Storyboard.showCommentComposer {
            let commentComposer = segue.destination as! CommentComposerViewController
            let selectedMedia = sender as! Media
            commentComposer.currentUser = currentUser
            commentComposer.media = selectedMedia
        }
    }
}

extension NewsFeedTableViewController: UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let _ = viewController as? DummyPostComposerViewController{
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
                
                let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as!
                UINavigationController
                
                let postComposerVC =  postComposerNVC.topViewController as! PostComposerViewController
                postComposerVC.image = image
                self.present(postComposerNVC, animated: true, completion: nil)
                
                
            })
            
            return false
        }
        
        return true
    }
}



// MARK : - UITABLEVIEWDATASOURCE 

extension NewsFeedTableViewController {
   
    override func numberOfSections(in tableView: UITableView) -> Int {
        return media.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if media.count == 0 {
            return 0
        }else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
        
        cell.currentUser = currentUser
        cell.media = media[indexPath.section]
        cell.selectionStyle = .none
        cell.delegate = self
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media[section]
        cell.backgroundColor = UIColor.white
        
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }


}

extension NewsFeedTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Storyboard.showMediaDetailSegue, sender: nil)
    }
}


extension NewsFeedTableViewController : MediaTableViewCellDelegate {
    func commentButtonDidTap(media: Media) {
        self.performSegue(withIdentifier: Storyboard.showCommentComposer, sender: media)
    }
}


