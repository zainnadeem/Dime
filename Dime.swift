
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
    
    var uid                     : String
    var caption                 : String
    var createdTime             : String
    //var coverMedia: Media
    var media                   : [Media]
    var createdBy               : User
    var likes                   : [User]
    var superLikes              : [User]
    var comments                : [Comment]
    var totalLikes              : Int
    
    
    init(caption: String, createdBy: User, media: [Media], totalLikes: Int)
    {
        
        self.caption = caption
        self.createdBy = createdBy
        self.media = media
        createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
        self.totalLikes = totalLikes
        comments = []
        likes = []
        superLikes = []
        uid = DatabaseReference.dimes.reference().childByAutoId().key
        
    }
    
    init (dictionary: [String: AnyObject]){
        
        uid = dictionary["uid"] as! String
        caption = dictionary["caption"] as! String
        createdTime = dictionary["createdTime"] as! String
        totalLikes = dictionary["totalLikes"] as! Int
        
        
        
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
    
    func save(completion: @escaping (Error?) -> Void) {
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
        
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
        }
        
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
    }
    
    func saveToUser(saveToUser user : User, completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.users(uid: user.uid).reference().child("dimes/\(uid)")
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
        
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
        }
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
    }
    
    func update(completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.dimes.reference().child(uid)
        ref.updateChildValues(updateDictionary())
        
        for media in media{
            let mediaRef = ref.child("media")
            mediaRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(media.uid){
                    
                    mediaRef.child("\(media.uid)").updateChildValues(media.updateDictionary())
                    
                    
                }else{
                    
                    mediaRef.child("\(media.uid)").setValue(media.toDictionary())
                    media.save(ref: ref, completion: { (error) in
                        if error != nil{
                            print(error?.localizedDescription)
                        }
                    })
                    
                    
                }
            })
        }

        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
        }
        
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
    }
    
    
    func updateDimeForUser(saveToUser user : User, completion: @escaping (Error?) -> Void) {
        let ref = DatabaseReference.users(uid: user.uid).reference().child("dimes/\(uid)")
        ref.updateChildValues(self.updateDictionary())
        
        
        for media in media{
            let mediaRef = ref.child("media")
            mediaRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                if snapshot.hasChild(media.uid){
                    
                    mediaRef.child("\(media.uid)").updateChildValues(media.updateDictionary())
                    
                    
                }else{
                    
                     mediaRef.child("\(media.uid)").setValue(media.toDictionary())
                     media.save(ref: ref, completion: { (error) in
                        if error != nil{
                            print(error?.localizedDescription)
                        }
                    })
                    
                    
                }
            })
        }
        
        //save likes
        for like in likes {
            ref.child("likes/\(like.uid)").setValue(like.toDictionary())
        }
        
        for superLike in superLikes {
            ref.child("superLikes/\(superLike.uid)").setValue(superLike.toDictionary())
        }
        
        //save comments
        for comment in comments {
            ref.child("comments/\(comment.uid)").setValue(comment.toDictionary())
        }
        
    }
    
    
    func updateDictionary() -> [String: Any] {
        
        
        return [
            "uid" : uid,
            "caption" : caption,
            "createdTime" : createdTime,
            "createdBy" : createdBy.toDictionary()

        ]
    }
    
    
    
    func toDictionary() -> [String: Any] {
        
        
        return [
            "uid" : uid,
            "caption" : caption,
            "createdTime" : createdTime,
            "totalLikes" : totalLikes,
            "createdBy" : createdBy.toDictionary()
            
            
        ]
    }
    
    func updateLikes(_ direction : UpdateDirection) {
        let ref = DatabaseReference.dimes.reference().child("\(uid)/totalLikes")
        let userRef = DatabaseReference.users(uid: createdBy.uid).reference().child("dimes/\(uid)/totalLikes")
        
        
        switch direction {
        case .increment:
            self.totalLikes += 1
            ref.setValue(totalLikes)
            userRef.setValue(totalLikes)
            
        case .decrement:
            self.totalLikes -= 1
            ref.setValue(totalLikes)
            userRef.setValue(totalLikes)
            
        }
    }
}

extension Dime {
    
    func updateOrCreateDime(completion: @escaping (Error?) -> Void){
        let ref = DatabaseReference.dimes.reference()
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.uid){
                
                self.update(completion: { (error) in
                    
                })
                
                
                self.updateDimeForUser(saveToUser: self.createdBy, completion: { (error) in
                    
                })
                
                
                
            }else{
                self.save(completion: { (error) in
                    print()
                })
                
                self.saveToUser(saveToUser: self.createdBy, completion: { (error) in
                    print()
                })
                
            }
            
            
        })
    }
    
    
    
    func downloadMediaImage(completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid: uid, completion: { (image, error)
            in
            completion(image, error)
        })
    }
    
    func downloadCoverImage(coverPhoto: String, completion: @escaping (UIImage?, Error?) -> Void) {
        
        FIRImage.downloadImage(uid: coverPhoto, completion: { (image, error)
            in
            completion(image, error)
        })
    }
    
    class func observeNewDime(_ completion: @escaping (Dime) -> Void) {
        
        DatabaseReference.dimes.reference().observe(.childAdded, with: { (snapshot) in
            let dime = Dime(dictionary: snapshot.value as! [String : AnyObject])
            completion(dime)
        })
    }
    
    class func observeNewDimeForUser(user: User, _ completion: @escaping (Dime) -> Void) {
        
        DatabaseReference.users(uid: user.uid).reference().child("dimes").observe(.childAdded, with: { (snapshot) in
            let dime = Dime(dictionary: snapshot.value as! [String : AnyObject])
            completion(dime)
        })
    }
    
    class func observeFriendsDimes(user: User, _ completion: @escaping (Dime) -> Void) {
        
        DatabaseReference.users(uid: user.uid).reference().child("dimes").observe(.childAdded, with: { (snapshot) in
            let dime = Dime(dictionary: snapshot.value as! [String : AnyObject])
            completion(dime)
        })
    }
    
    
    func updateDatabase(completion: @escaping (Error?) -> Void) {
        
        let ref = DatabaseReference.dimes.reference().child(uid)
        ref.updateChildValues(self.toDictionary(), withCompletionBlock: { (error, dbRef) in
            if let error = error {
                print("Error updating database. \(error.localizedDescription)")
            } else {
                print("Successfully updated database with new info: \(self.uid).")
                print("DB Description: \(dbRef.description())")
            }
        })
        
    }
    
    func observeNewComment(_ completion: @escaping (Comment) -> Void){
        DatabaseReference.dimes.reference().child("\(uid)/comments").observe(.childAdded, with: { snapshot in
            let comment = Comment(dictionary: snapshot.value as! [String : AnyObject])
            completion(comment)
        })
    }
    
    func superLikedBy(user: User) {
        self.superLikes.append(user)
        let ref = DatabaseReference.dimes.reference().child("\(uid)/superLikes/\(user.uid)")
        
        ref.setValue(user.toDictionary())
    }
    
    func unSuperLikedBy(user: User){
        if let index = superLikes.index(of: user){
            superLikes.remove(at: index)
            let ref = DatabaseReference.dimes.reference().child("\(uid)/superLikes/\(user.uid)")
            
            ref.setValue(nil)
        }
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

func sortByMostRecentlyCreated(_ arrayOfDimes : [Dime]) -> [Dime] {
    
    var dimes = arrayOfDimes
    dimes.sort(by: { return $0 > $1 })
    return dimes
}

func sortByTrending(_ arrayOfDimes: [Dime]) -> [Dime] {
    var dimes = arrayOfDimes
    //    for dime in dimes {
    //        dime.totalLikes = 0
    //        for media in dime.media{
    //             dime.totalLikes! += media.likes.count
    //        }
    //    }
    dimes.sort(by: {$0.totalLikes > $1.totalLikes})
    return dimes
}

func >(lhs: Dime, rhs: Dime) -> Bool {
    
    let lhsDime = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsDime = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsDime?.compare(rhsDime!) == .orderedDescending ? true : false
}

func <(lhs: Dime, rhs: Dime) -> Bool {
    
    let lhsDime = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsDime = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsDime?.compare(rhsDime!) == .orderedDescending ? false : true
}

enum UpdateDirection : Int {
    case increment = 1
    case decrement = -1
}








