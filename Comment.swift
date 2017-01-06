//
//  Comment.swift
//  Moments
//
//  Created by Zain Nadeem on 11/15/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Firebase
import UIKit



class Comment{
    var mediaUID: String
    var dimeUID: String
    var uid: String
    var createdTime: String
    var from: User
    var caption: String
    var ref: FIRDatabaseReference

    
    init(dimeUID: String, mediaUID: String, from: User, caption: String) {
        self.mediaUID = mediaUID
        self.dimeUID = dimeUID
        self.from = from
        self.caption = caption
        
        self.createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
        ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(mediaUID)/comments").childByAutoId()
        uid = ref.key
        
    }
    
    init(dictionary: [String : Any]) {
        
        uid = dictionary["uid"] as! String
        createdTime = dictionary["createdTime"] as! String
        caption = dictionary["caption"] as! String
        
        let fromDictionary = dictionary["from"] as! [String : Any]
        from = User(dictionary: fromDictionary)
        
        mediaUID = dictionary["mediaUID"] as! String
        dimeUID = dictionary["dimeUID"] as! String
        ref = DatabaseReference.dimes.reference().child("\(dimeUID)/media/\(mediaUID)/comments/\(uid)")
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
            "createdTime" : createdTime,
            "from" : from.toDictionary(),
            "caption" : caption
        ]
    }
}

extension Comment : Equatable{ }

func == (lhs: Comment, rhs: Comment) -> Bool {
    return lhs.uid == rhs.uid
}


 func sortByMostRecentlyCreated(_ arrayOfComments : [Comment]) -> [Comment] {
    
    var comments = arrayOfComments
    comments.sort(by: { return $0 > $1 })
    return comments
}


//func ==(lhs: Comment, rhs: Comment) -> Bool {
//    return lhs.savedPathURL == rhs.savedPathURL
//}

func >(lhs: Comment, rhs: Comment) -> Bool {
    
    let lhsComment = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsComment = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsComment?.compare(rhsComment!) == .orderedDescending ? true : false
}

func <(lhs: Comment, rhs: Comment) -> Bool {
    
    let lhsComment = Constants.dateFormatter().date(from: lhs.createdTime)
    let rhsComment = Constants.dateFormatter().date(from: rhs.createdTime)
    
    return lhsComment?.compare(rhsComment!) == .orderedDescending ? false : true
}




//Sort




