//
//  Media.swift
//  Dime
//
//  Created by Zain Nadeem on 11/8/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase


class Media {
    
    var uid: String
    var dimeUID: String
    var type: String //"image" or "video"
    var caption: String
    var location: String
    var createdTime: String
    var createdBy: User
    
    var likes: [User]
    var likesCount: Int
    
    var superLikes: [User]
    var superLikesCount: Int
    
    var usersTagged: [User]
    var comments: [Comment]
    var mediaURL: String
    var mediaImage: UIImage!
    
    
    init(dimeUID: String, type: String, caption: String, createdBy: User, mediaURL: String, location: String, mediaImage:UIImage, likesCount: Int, superLikesCount: Int)
    {
        self.type = type
        self.caption = caption
        self.createdBy = createdBy
        self.mediaURL = mediaURL
        self.location = location
        self.dimeUID = dimeUID
        self.mediaImage = mediaImage
        
        self.likesCount = likesCount
        self.superLikesCount = superLikesCount
        
        createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
        comments = []
        likes = []
        superLikes = []
        usersTagged = []
        uid = DatabaseReference.media.reference().childByAutoId().key
    }
    
    init (dictionary: [String: Any]){
        
        uid = dictionary["uid"] as! String
        dimeUID = dictionary["dimeUID"] as! String
        type = dictionary["type"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! String
        location = dictionary["location"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        likesCount = dictionary["likesCount"] as! Int
        superLikesCount = dictionary["superLikesCount"] as! Int
        
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
        
        superLikes = []
        if let superLikesDict = dictionary["superLikes"] as? [String : Any] {
            for (_, userDict) in superLikesDict {
                if let userDict = userDict as? [String: Any] {
                    superLikes.append(User(dictionary: userDict))
                }
            }
        }
        
        
        comments = []
        if let commentsDict = dictionary["comments"] as? [String : Any] {
            for (_, commentDict) in commentsDict {
                if let commentDict = commentDict as? [String: Any] {
                    comments.append(Comment(dictionary: commentDict))
                }
            }
        }
        
        
        usersTagged = []
        if let usersDict = dictionary["users tagged"] as? [String : Any] {
            for (_, userDict) in usersDict {
                if let userDict = userDict as? [String: Any] {
                    usersTagged.append(User(dictionary: userDict))
                }
            }
        }
    }
    
    func save(ref: FIRDatabaseReference, completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)")
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("dimes/\(dimeUID)/media/\(uid)")
        //ref.setValue(toDictionary())
        
        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        //save superLikes
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
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
        
        if type == "video" {
            let firVideo = FIRVideo(videoURL: URL(fileURLWithPath: mediaURL))
            firVideo.save(self.uid, completion: { (meta, error) in
            
            ref.child("mediaURL").setValue(meta?.downloadURL()?.absoluteString)
            userRef.child("mediaURL").setValue(meta?.downloadURL()?.absoluteString)
            
            })
}
    }
    
    func saveDraft(ref :FIRDatabaseReference, completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.drafts.reference().child("\(dimeUID)/media/\(uid)")
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("drafts/\(dimeUID)/media/\(uid)")
        //ref.setValue(toDictionary())
        
        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        //save superLikes
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
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
        
        if type == "video" {
            let firVideo = FIRVideo(videoURL: URL(fileURLWithPath: mediaURL))
            firVideo.save(self.uid, completion: { (meta, error) in
                
                ref.child("mediaURL").setValue(meta?.downloadURL()?.absoluteString)
                userRef.child("mediaURL").setValue(meta?.downloadURL()?.absoluteString)
                
            })
        }
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "dimeUID" : dimeUID,
            "type" : type,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary(),
            "mediaURL"  : mediaURL,
            "likesCount": likesCount,
            "superLikesCount": superLikesCount,
            "location"  : location
        ]
    }
    
    func updateDictionary() -> [String: Any] {
        return [
            "uid" : uid,
            "dimeUID" : dimeUID,
            "type" : type,
            "caption" : caption,
            "createdBy" : createdBy.toDictionary(),
            "mediaURL"  : mediaURL,
            "location"  : location
        ]
    }
    
    func updateLikes(_ direction : UpdateDirection) {
        let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/likesCount")
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("dimes/\(dimeUID)/media/\(uid)/likesCount")
        
        switch direction {
        case .increment:
            self.likesCount += 1
            ref.setValue(likesCount)
            userRef.setValue(likesCount)
            
        case .decrement:
            self.likesCount -= 1
            ref.setValue(likesCount)
            userRef.setValue(likesCount)
            
        }
    }
    
    func updateSuperLikes(_ direction : UpdateDirection) {
        
        let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/superLikesCount")
        
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("dimes/\(dimeUID)/media/\(uid)/superLikesCount")
        
        switch direction {
        case .increment:
            self.superLikesCount += 1
            ref.setValue(superLikesCount)
            userRef.setValue(superLikesCount)
            
        case .decrement:
            self.superLikesCount -= 1
            ref.setValue(superLikesCount)
            userRef.setValue(superLikesCount)
            
        }
    }


}

extension Media {
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid: uid, completion: { (image, error)
            in
            completion(image, error)
        })
    }
    
    
   
    func downloadVideo(completion: @escaping (URL?, Error?) -> Void) {
        
        StorageReference.videos.reference().child(uid).downloadURL { (url, error) in
            
            completion(url, error)

        }
        
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
        let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/likes/\(user.uid)")
        ref.setValue(user.toDictionary())
    }
    
    func unlikedBy(user: User){
        if let index = likes.index(of: user){
            likes.remove(at: index)
            let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/likes/\(user.uid)")
            ref.setValue(nil)
        }
    }
    
    func superLikedBy(user: User) {
        self.superLikes.append(user)
        let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/superLikes/\(user.uid)")
        ref.setValue(user.toDictionary())
    }
    
    func unSuperLikedBy(user: User){
        if let index = superLikes.index(of: user){
            superLikes.remove(at: index)
            let ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)/superLikes/\(user.uid)")
            ref.setValue(nil)
        }
    }
    
    func deleteMediaFromFireBase(){
        let dimeRef = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(uid)")
        dimeRef.setValue(nil)
        
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("dimes/\(dimeUID)/media/\(uid)")
        userRef.setValue(nil)
    }
}


extension Media: Equatable { }

func ==(lhs: Media, rhs: Media) -> Bool {
    return lhs.uid == rhs.uid
    
}

func sortByMostRecentlyCreated(_ arrayOfMedia : [Media]) -> [Media] {
    
    var dime = arrayOfMedia
    dime.sort(by: { return $0 > $1 })
    return dime
}

func sortByOrderCreated(_ arrayOfMedia : [Media]) -> [Media] {
    
    var dime = arrayOfMedia
    dime.sort(by: { return $0 < $1 })
    return dime
}

func >(lhs: Media, rhs: Media) -> Bool {
    
    let lhsMedia = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsMedia = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsMedia?.compare(rhsMedia!) == .orderedDescending ? true : false
}

func <(lhs: Media, rhs: Media) -> Bool {
    
    let lhsMedia = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsMedia = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsMedia?.compare(rhsMedia!) == .orderedAscending ? true : false
}






