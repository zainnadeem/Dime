//
//  Dime.swift
//  Dime
//
//  Created by Zain Nadeem on 11/21/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Firebase
import UIKit

class Dime {
    
    var uid: String
    var caption: String
    var createdTime: String
    //var coverMedia: Media
    var media: [Media]
    var createdBy: User
    var likes: [User]
    var comments: [Comment]
    
    
    init(caption: String, createdBy: User, media: [Media])
    {
    
        self.caption = caption
        self.createdBy = createdBy
        self.media = media
        createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
        comments = []
        likes = []
        uid = DatabaseReference.dimes.reference().childByAutoId().key
        
    }
    
    init (dictionary: [String: Any]){
        
        uid = dictionary["uid"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! String
        
        let createdByDict = dictionary["createdBy"] as! [String : Any]
        createdBy = User(dictionary: createdByDict)

        
        likes = []
        if let likesDict = dictionary["likes"] as? [String : Any] {
            for (_, userDict) in likesDict {
                if let userDict = userDict as? [String: Any] {
                    likes.append(User(dictionary: userDict))
                }
            }
        }
        
        media = []
        if let mediaDict = dictionary["media"] as? [String : Any] {
            for (_, mediaDict) in mediaDict {
                if let mediaDict = mediaDict as? [String: Any] {
                    media.append(Media(dictionary: mediaDict))
                }
            }
        }

        comments = []
    }
    
    func save(caption: String, completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.dimes.reference().child(uid)
        ref.setValue(toDictionary())
        
        for media in media{
            ref.child("media/\(media.uid)").setValue(media.toDictionary())
            media.save(ref: ref, completion: { (error) in
                if error != nil{
                    print(error?.localizedDescription)
                }
            })
        }
        
        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        

    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary()
            
        ]
    }
}

extension Dime {
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid: uid, completion: { (image, error)
            in
            completion(image, error)
        })
    }
    
    class func observeNewDime(_ completion: @escaping (Dime) -> Void) {
        
        DatabaseReference.dimes.reference().observe(.childAdded, with: { (snapshot) in
            let dime = Dime(dictionary: snapshot.value as! [String : Any])
            completion(dime)
        })
    }
    
    
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void){
        //.childAdded: (1) download everything fo the first time
        //(2)download the new child added to the ref
        DatabaseReference.dimes.reference().child("\(uid)/comments").observe(.childAdded, with: { snapshot in
            let comment = Comment(dictionary: snapshot.value as! [String : Any])
            completion(comment)
        })
    }
    
    func likedBy(user: User) {
        self.likes.append(user)
        let ref = DatabaseReference.dimes.reference().child("\(uid)/likes/\(user.uid)")
        
        ref.setValue(user.toDictionary())
    }
    
    func unlikedBy(user: User){
        if let index = likes.index(of: user){
            likes.remove(at: index)
            let ref = DatabaseReference.dimes.reference().child("\(uid)/likes/\(user.uid)")
            
            ref.setValue(nil)
        }
    }
}


extension Dime: Equatable { }

func ==(lhs: Dime, rhs: Dime) -> Bool {
    return lhs.uid == rhs.uid
    
}



