//
//  Media.swift
//  Moments
//
//  Created by Zain Nadeem on 11/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase


class Media {
    
    var uid: String
    let type: String //"image" or "video"
    var caption: String
    var location: String
    var createdTime: Double
    var createdBy: User
    var likes: [User]
    var usersTagged: [User]
    var comments: [Comment]
    var mediaImage: UIImage!
    
//    init(type: String, caption: String, createdBy: User, image: UIImage)
//    {
//        self.type = type
//        self.caption = caption
//        self.createdBy = createdBy
//        self.mediaImage = image
//        
//        
//        createdTime = Date().timeIntervalSince1970 // number of seconds from 1970 to now
//        comments = []
//        likes = []
//        uid = DatabaseReference.media.reference().childByAutoId().key
//        
//    }
    
    init(type: String, caption: String, createdBy: User, image: UIImage, location: String)
    {
        self.type = type
        self.caption = caption
        self.createdBy = createdBy
        self.mediaImage = image
        self.location = location
        
        createdTime = Date().timeIntervalSince1970 // number of seconds from 1970 to now
        comments = []
        likes = []
        usersTagged = []
        uid = DatabaseReference.media.reference().childByAutoId().key
        
    }
    
    init (dictionary: [String: Any]){
        
        uid = dictionary["uid"] as! String
        type = dictionary["type"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! Double
        location = dictionary["location"] as! String
        
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
        
        comments = []
        usersTagged = []
    }
    
    func save(ref: FIRDatabaseReference, completion: @escaping (Error?) -> Void) {
//        let ref = DatabaseReference.media.reference().child(uid)
//        ref.setValue(toDictionary())
        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
        for user in usersTagged {
            ref.child("users tagged/\(user.uid)").setValue(user.toDictionary())
        }
        
        //upload image to storage database
        let firImage = FIRImage(image: mediaImage)
        firImage.save(self.uid, completion: { error in
            completion(error)
        })
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "type" : type,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary(),
            "location"  : location
        ]
    }
}

extension Media {
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid: uid, completion: { (image, error)
            in
            completion(image, error)
        })
    }
    
    class func observeNewMedia(_ completion: @escaping (Media) -> Void) {
        
        DatabaseReference.media.reference().observe(.childAdded, with: { (snapshot) in
            let media = Media(dictionary: snapshot.value as! [String : Any])
            completion(media)
        })
    }
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void){
        //.childAdded: (1) download everything fo the first time
        //(2)download the new child added to the ref
        DatabaseReference.media.reference().child("\(uid)/comments").observe(.childAdded, with: { snapshot in
            let comment = Comment(dictionary: snapshot.value as! [String : Any])
            completion(comment)
        })
    }
    
    func likedBy(user: User) {
        self.likes.append(user)
        let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
        
        ref.setValue(user.toDictionary())
    }
    
    func unlikedBy(user: User){
        if let index = likes.index(of: user){
            likes.remove(at: index)
            let ref = DatabaseReference.media.reference().child("\(uid)/likes/\(user.uid)")
            
            ref.setValue(nil)
        }
    }
}


extension Media: Equatable { }

func ==(lhs: Media, rhs: Media) -> Bool {
    return lhs.uid == rhs.uid
    
}





