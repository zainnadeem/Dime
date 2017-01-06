//
//  Notification.swift
//  Dime
//
//  Created by Zain Nadeem on 1/3/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import Firebase
import UIKit

enum NotificationType {
    case like
    case comment
    case friendRequest
}


class Notification{
    var mediaUID: String
    var dimeUID: String
    var uid: String
    var createdTime: String
    var from: User
    var toUser: String
    var caption: String
    var notificationType: String
    var ref: FIRDatabaseReference
    
    
    init(dimeUID: String, mediaUID: String, toUser: String, from: User, caption: String, notificationType: String) {
        self.mediaUID = mediaUID
        self.dimeUID = dimeUID
        self.from = from
        self.caption = caption
        self.toUser = toUser
        self.notificationType = notificationType
        
        self.createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
   
        ref = DatabaseReference.users(uid: toUser).reference().child("notifications").childByAutoId()
        uid = ref.key
        
    }
    
    init(dictionary: [String : Any]) {
        
        uid = dictionary["uid"] as! String
        createdTime = dictionary["createdTime"] as! String
        caption = dictionary["caption"] as! String
        notificationType = dictionary["notificationType"] as! String
        
        let fromDictionary = dictionary["from"] as! [String : Any]
        from = User(dictionary: fromDictionary)
        
        toUser = dictionary["toUser"] as! String
        mediaUID = dictionary["mediaUID"] as! String
        dimeUID = dictionary["dimeUID"] as! String
        ref = DatabaseReference.users(uid: uid).reference().child("notifications/\(uid)")
    }
    
    func save(){
        ref.setValue(toDictionary())
    }
    
    func toDictionary() -> [String : Any]
    {
        return [
            "mediaUID" : mediaUID,
            "dimeUID"  : dimeUID,
            "uid" : uid,
            "notificationType" : notificationType,
            "toUser" : toUser,
            "createdTime" : createdTime,
            "from" : from.toDictionary(),
            "caption" : caption
        ]
    }


}


extension Notification : Equatable{ }

func == (lhs: Notification, rhs: Notification) -> Bool {
    return lhs.uid == rhs.uid
}


func sortByMostRecentlyCreated(_ arrayOfNotifications : [Notification]) -> [Notification] {
    
    var notification = arrayOfNotifications
    notification.sort(by: { return $0 > $1 })
    return notification
}


//func ==(lhs: Comment, rhs: Comment) -> Bool {
//    return lhs.savedPathURL == rhs.savedPathURL
//}

func >(lhs: Notification, rhs: Notification) -> Bool {
    
    let lhsNotification = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsNotification = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsNotification?.compare(rhsNotification!) == .orderedDescending ? true : false
}

func <(lhs: Notification, rhs: Notification) -> Bool {
    
    let lhsNotification = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsNotification = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsNotification?.compare(rhsNotification!) == .orderedDescending ? false : true
}
