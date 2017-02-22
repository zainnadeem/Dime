//
//  Datastore.swift
//  Dime
//
//  Created by Zain Nadeem on 11/5/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit
import SAMCache
import Firebase
import OneSignal

class DataStore {
    
    static let sharedInstance = DataStore()
    
    var currentUser: User?
    
    var currentDime: Dime?

    var chatKeys = [String]()
    var chats = [Chat]()
    
    var cache = SAMCache.shared()
    
    
    func getCurrentDime(){
        
        if var dimes = currentUser?.dimes{
            if dimes.count > 0{
                dimes = sortByMostRecentlyCreated(dimes)
                let lastDimeCreatedTime = dimes.first?.createdTime
                if self.isDimeWithinOneDay(videoDate: lastDimeCreatedTime!){
                    
                    self.currentDime = dimes.first
                    self.currentDime?.media = sortByMostRecentlyCreated((self.currentDime?.media)!)
                    
                    self.getImages({
                        
                    })
                }
                
            }
        }
    }
    
    func getImages( _ completion: @escaping () -> Void){
        if currentDime != nil{
            for media in (currentDime?.media)!{
                if let image = cache?.object(forKey: "\(media.uid)-mediaImage") as? UIImage
                {
                    media.mediaImage = image
                }else {
                    media.downloadMediaImage(completion: { [weak self] (image, error) in
                        if let image = image {
                            media.mediaImage = image
                            self?.cache?.setObject(image, forKey: "\(media.uid)-mediaImage")
                        }
                    })
                }
            }
            completion()
        }
    }
    
    func updateMediaCount(){
        guard let currentUser = self.currentUser else { return }
        let ref = DatabaseReference.users(uid: currentUser.uid).reference().child("mediaCount")
        var mediaCount = 0
        for dimes in currentUser.dimes {
            for media in dimes.media {
                mediaCount += 1
            }
        }
        
        ref.setValue(mediaCount)
    }
    
    
    
    func isDimeWithinOneDay(videoDate date : String) -> Bool {
        if let creationDate = Constants.dateFormatter().date(from: date) {
            
            let yesterday = Constants.dateFormatter().date(from: Constants.oneDayAgo())!
            
            if creationDate.compare(yesterday) == .orderedDescending { return true }
            else if creationDate.compare(yesterday) == .orderedSame  { return true }
            else { return false }
            
        } else {
            print("Couldn't get NSDate object from string date arguement")
            return false
        }
    }
    
    func observeChats(_ completion: @escaping ([String]) -> Void) {
        guard let user = currentUser else { return }
        
        DatabaseReference.users(uid: user.uid).reference().child("chatIds").observe(.childAdded, with: { snapshot in
            
            print(snapshot.key)
            
            DatabaseReference.chats.reference().child(snapshot.key).observeSingleEvent(of: .value, with: { (snap) in
                guard let data = snap.value as? [String: AnyObject] else { return }
                
                print("++++++++++++")
                print(data)
                print("++++++++++++")
                
                let chat = Chat(dictionary: data)
                self.chats.append(chat)
            })
            
            
        })
        
    }
    
    func alreadyAdded(_ chat: Chat) -> Bool {
        for c in self.chats {
            if c.uid == chat.uid {
                return true
            }
        }
        
        return false
    }
    
    func updateFriends(){
        guard let user = currentUser else { return }
        for friend in user.friends{
            friend.getTotalLikes()
        }
        
    }
    
    
    
    func updateFriendsRefresh(_ completion: @escaping () -> Void){
        
        guard let user = currentUser else { return }
        for friend in user.friends{
            friend.getTotalLikes()
        }
        
        completion()
        
    }
    
    
    func registerOneSignalToken(user: User){
        
        OneSignal.idsAvailable({ (userID, pushToken) in
            if userID != nil {
                if !(user.deviceTokens.contains(userID!)){
                    user.deviceTokens.append(userID!)
                    DatabaseReference.users(uid: user.uid).reference().child("deviceTokens").setValue(user.deviceTokens)
                    
                }
                
            }
        })
    }
    
    
}
