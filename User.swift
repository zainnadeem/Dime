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
    
    let uid: String
    var username: String
    var fullName: String
    var bio: String
    var website: String
    var profileImage: UIImage?
    var friends: [User]
    var topFriends: [User]
    var dimes: [Dime]
    
    
    // Mark: - Initialize   rs
    
    init(uid: String, username: String, fullName: String, bio: String, website: String, friends: [User], topFriends: [User], profileImage: UIImage?, dimes: [Dime])
        
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
        
    }
    
    
    
    init(dictionary: [String : Any]){
        uid = dictionary["uid"] as! String
        username = dictionary["username"] as! String
        fullName = dictionary["fullName"] as! String
        bio = dictionary["bio"] as! String
        website = dictionary["website"] as! String
        
        
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
        if let dimesDict = dictionary["dimes"] as? [String : Any]
        {
            for (_, dimeDict) in dimesDict {
                if let dimeDict = dimeDict as? [String : Any] {
                    self.dimes.append(Dime(dictionary: dimeDict))
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
    
    func friendUser(user: User) {
        self.friends.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("friends/\(user.uid)")
        ref.setValue(user.toDictionary())
    }
    
    func topFriendUser(user: User) {
        self.topFriends.append(user)
        let ref = DatabaseReference.users(uid: uid).reference().child("topFriends/\(user.uid)")
        ref.setValue(user.toDictionary())
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




}

extension User: Equatable { }
//teach swift to compare to instances of a class
func == (lhs: User, rhs: User) -> Bool {
    return lhs.uid == rhs.uid
}


    
    
    

