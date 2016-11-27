//
//  MediaDetailTableViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/15/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase

class MediaDetailTableViewController: UITableViewController {
    
    var media: Media!
    var currentUser: User!
    var comments = [Comment]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title =  "Photo"
        
        tableView.allowsSelection = false
        tableView.estimatedRowHeight = Storyboard.mediaCellDefaultHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        
        comments = media.comments
        tableView.reloadData()
        
        self.fetchComments()
        
    }
    
    func fetchComments(){
        media.observeNewComment { (comment) in
            if !self.comments.contains(comment){
                self.comments.insert(comment, at: 0)
                self.tableView.reloadData()
                
            }
        }
    }
    
    //MARK
    @IBAction func commentDidTap() {
        self.performSegue(withIdentifier: Storyboard.showCommentComposer, sender: media)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.showCommentComposer{
            let commentComposer = segue.destination as! CommentComposerViewController
            commentComposer.media = media
            commentComposer.currentUser = currentUser
            
        }
    }
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1 + comments.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.row == 0{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaTableViewCell
            
            cell.currentUser = currentUser
            cell.media = media
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.commentCell, for: indexPath) as! CommentTableViewCell
            
            cell.comment = comments[indexPath.row - 1]
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.mediaHeaderCell) as! MediaHeaderCell
        
        cell.currentUser = currentUser
        cell.media = media
        cell.backgroundColor = UIColor.white
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Storyboard.mediaHeaderHeight
    }
}
