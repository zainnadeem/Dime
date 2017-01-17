//
//  User.swift
//  Dime
//
//  Created by Zain Nadeem on 10/29/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation
import Firebase

class User {
    
    
    let uid                       : String
    var username                  : String
    var fullName                  : String
    var bio                       : String
    var website                   : String
    var lastSuperLikeTime         : String
    
    var profileImage              : UIImage?
    var friends                   : [User]
    var topFriends                : [User]
    var dimes                     : [Dime]
    var notifications             : [Notification]
    
    var totalLikes                : Int
    var averageLikesCount         : Int
    var mediaCount                : Int
    var popularRank               : Int
    
    let store = DataStore.sharedInstance
    
    
    // Mark: - Initialize   rs
    
    init(uid: String, username: String, fullName: String, bio: String, website: String, friends: [User], topFriends: [User], profileImage: UIImage?, dimes: [Dime], notifications: [Notification], totalLikes: Int, averageLikesCount: Int, mediaCount: Int, popularRank: Int)
        
    {
        self.uid = uid
        self.username = username
        self.fullName = fullName
        self.bio = bio
        self.website = website
        self.friends = friends
        self.topFriends = friends
        self.profileImage = profileImage
        self.dimes = dimes
        self.notifications = notifications
        self.totalLikes = totalLikes
        self.averageLikesCount = averageLikesCount
        self.mediaCount = mediaCount
        self.popularRank = popularRank
        self.lastSuperLikeTime = Constants.oneDayAgo()
        
        
    }
    
    
    
    init(dictionary: [String : Any]){
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        lastSuperLikeTime = dictionary["lastSuperLikeTime"] as! String
        
        totalLikes = dictionary["totalLikes"] as! Int
        mediaCount = dictionary["mediaCount"] as! Int
        averageLikesCount = dictionary["averageLikesCount"] as! Int
        popularRank = dictionary["popularRank"] as! Int
        
        //follows
        self.friends = []
        if let friendsDict = dictionary["friends"] as? [String : Any]
        {
            for (_, userDict) in friendsDict {
                if let userDict = userDict as? [String : Any]{
                    self.friends.append(User(dictionary: userDict))
                }
            }
        }
        
        //followedBy
        self.topFriends = []
        if let topFriendsDict = dictionary["topFriends"] as? [String : Any]
        {
            for (_, userDict) in topFriendsDict {
                if let userDict = userDict as? [String : Any]{
                    self.topFriends.append(User(dictionary: userDict))
                }
            }
        }

        //dimeAlbum
        self.dimes = []
        if let dimesDict = dictionary["dimes"] as? [String : AnyObject]
        {
            for (_, dimeDict) in dimesDict {
                if let dimeDict = dimeDict as? [String : AnyObject] {
                    self.dimes.append(Dime(dictionary: dimeDict))
                }
            }
        }
        
        //notifications
        self.notifications = []
        if let notificationsDict = dictionary["notifications"] as? [String : Any]
        {
            for (_, notificationDict) in notificationsDict {
                if let notificationDict = notificationDict as? [String : Any] {
                    self.notifications.append(Notification(dictionary: notificationDict))
                }
            }
        }
  
    }
    
    func save(completion: @escaping (Error?) -> Void){
        let ref = DatabaseReference.users(uid: uid).reference()
        ref.setValue(toDictionary())
        
        //2 - save follows
        for user in friends {
            ref.child("friends/\(user.uid)").setValue(user.toDictionary())
        }
        
        //3 save the followed by
        for user in topFriends {
            ref.child("topFriends/\(user.uid)").setValue(user.toDictionary())
        }
        //4 - save the profile image
        if let profileImage = self.profileImage {
            let firImage = FIRImage(image: profileImage)
            firImage.saveProfileImage(self.uid, { (error) in
                completion(error)
            })
        }
        
    }
    
    func toDictionary() -> [String : Any] {
        return [
            "uid" : uid,
            "username" : username,
            "fullName" : fullName,
            "bio" : bio,
            "lastSuperLikeTime" : lastSuperLikeTime,
            "totalLikes" : totalLikes,
            "averageLikesCount" : averageLikesCount,
            "mediaCount" : mediaCount,
            "popularRank": popularRank,
            "website" : website
            
        ]
        
    }
    
}

extension User {
    func share(newMedia: Media){
        DatabaseReference.users(uid: uid).reference().child("media").childByAutoId().setValue(newMedia.uid)
        
    }
    
    func shareDime(newDime: Dime){
        DatabaseReference.users(uid: uid).reference().child("dimes").childByAutoId().setValue(newDime.uid)
    }
    
    func addToDime(newMedia: Media, caption: String){
        DatabaseReference.users(uid: uid).reference().child("dimes").childByAutoId().setValue(newMedia.uid)
    }
    
    func downloadProfilePicture(completion: @escaping (UIImage?, NSError?) -> Void){
        FIRImage.downloadProfileImage(uid, completion: { (image, error) in
            self.profileImage = image
            completion(image, error as NSError?)
        })
    }
    
    func superLiked(){
        let currentTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
        self.lastSuperLikeTime = currentTime
        let ref = DatabaseReference.users(uid: uid).reference().child("lastSuperLikeTime")
        ref.setValue(currentTime)
    }
    
    func friendUser(user: User) {
        self.friends.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("friends/\(user.uid)")
        ref.setValue(user.toDictionary())
        
        
    }
    
    func unFriendUser(user: User){
        self.friends = self.friends.filter() {$0 !== user}
        let ref = DatabaseReference.users(uid: uid).reference().child("friends/\(user.uid)")
        ref.setValue(nil)
        
    }
    
    func topFriendUser(user: User) {
        self.topFriends.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("topFriends/\(user.uid)")
        ref.setValue(user.toDictionary())
        
    }
    func unTopFriendUser(user: User){
        self.topFriends = self.topFriends.filter() {$0 !== user}
        let ref = DatabaseReference.users(uid: uid).reference().child("topFriends/\(user.uid)")
        ref.setValue(nil)
        
    }
   
    func addNotification(notification: Notification){
        self.notifications.append(notification)
        let ref = DatabaseReference.users(uid: uid).reference().child("notifications/\(notification.uid)")
        ref.setValue(notification.toDictionary())
        
    }

    
    func observeNewNotification(_ completion: @escaping (Notification) -> Void){
        //.childAdded: (1) download everything fo the first time
        //(2)download the new child added to the ref
        DatabaseReference.users(uid: uid).reference().child("notifications").observe(.childAdded, with: { snapshot in
            let notification = Notification(dictionary: snapshot.value as! [String : Any])
            completion(notification)
        })
    }

   func UserFromSnapshot(_ snapshot : FIRDataSnapshot, uid : String) -> User? {
        
        if let userDictionary = snapshot.value as? [String : AnyObject] {
            
            return User(dictionary: userDictionary)
        }
        else {
            print("Couldn't get Consumer info from Firebase snapshot.")
            return nil
        }
    }
    
    func save(new chat: Chat){
        DatabaseReference.users(uid: self.uid).reference().child("chatIds/\(chat.uid)").setValue(true)
    }




}

//update media count, Average & popular rank
extension User {
    
    func updateMediaCount(_ direction : UpdateDirection, amount: Int) {
        let ref = DatabaseReference.users(uid: uid).reference().child("mediaCount")
        
        switch direction {
        case .increment:
            self.mediaCount += 1
            ref.setValue(mediaCount)
        case .decrement:
            self.mediaCount -= 1
            ref.setValue(mediaCount)
        }
        updateAverageLikes()
        
    }
    
    
    func updateTotalLikesCount(_ direction : UpdateDirection) {
        guard let currentUser = self.store.currentUser else { return }
        
        let ref = DatabaseReference.users(uid: uid).reference().child("totalLikes")
        let userFriendRef = DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(uid)/totalLikes")
        
        ref.observeSingleEvent(of: .value, with: { total in
            
            self.totalLikes = total.value as! Int
            
            switch direction {
            case .increment:
                self.totalLikes += 1
                ref.setValue(self.totalLikes)
                userFriendRef.setValue(self.totalLikes)
                
            case .decrement:
                self.totalLikes -= 1
                ref.setValue(self.totalLikes)
                userFriendRef.setValue(self.totalLikes)
            }
            
            self.updateAverageLikes()

        })

        
    }
    
    func getTotalLikes(){
        guard let currentUser = self.store.currentUser else { return }
        
        let ref = DatabaseReference.users(uid: uid).reference().child("totalLikes")
        let userFriendRef = DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(uid)/totalLikes")
        
        ref.observeSingleEvent(of: .value, with: { total in
            
            self.totalLikes = total.value as! Int
            
                userFriendRef.setValue(self.totalLikes)
                self.updateAverageLikes()
        })
        
    }
    
    func updateAverageLikes() {
        guard let currentUser = self.store.currentUser else { return }
        
        let ref = DatabaseReference.users(uid: uid).reference().child("averageLikesCount")
        
        let userFriendRef = DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(uid)/averageLikesCount")
        
        if totalLikes > 0 {
        
        let average = (self.totalLikes / self.mediaCount) as Int
        self.averageLikesCount = average
        
        ref.setValue(self.averageLikesCount)
        userFriendRef.setValue(self.averageLikesCount)

        }
        
        updatePopularRank()
    }
    
    func updatePopularRank(){
        guard let currentUser = self.store.currentUser else { return }
        
        let ref = DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(uid)")
        
        
        if !currentUser.friends.contains(currentUser){
            currentUser.friends.append(currentUser)
            DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(uid)").setValue(currentUser.toDictionary())
        }
        
        
        if currentUser.friends.count > 1{
        
        let popularRankedFriends = sortByAverageLikes(currentUser.friends)
        
        //ref.child("popularRank").setValue(popularRankedFriends.index(of: self))
            
            for user in currentUser.friends {
                //if user == currentUser {ref.setValue(currentUser.toDictionary())}
                user.popularRank = popularRankedFriends.index(of: user)! + 1
                DatabaseReference.users(uid: currentUser.uid).reference().child("friends/\(user.uid)/popularRank").setValue(user.popularRank)
                
            }
        
            if currentUser == self {
                    let currentUserRef = DatabaseReference.users(uid: uid).reference().child("popularRank")
                    currentUserRef.setValue(popularRankedFriends.index(of: currentUser)! + 1)
            }
        
        }
    }

}


extension User: Equatable { }
//teach swift to compare to instances of a class
func == (lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}

func sortByAverageLikes(_ arrayOfUsers: [User]) -> [User] {
    var users = arrayOfUsers
    users.sort(by: {$0.averageLikesCount > $1.averageLikesCount})
    return users
}







