//
//  Message.swift
//  Dime
//
//  Created by Zain Nadeem on 1/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import Foundation
import Firebase


public struct MessageType {
    static let text = "text"
    static let image = "image"
    static let video  = "video"
}


class Message{
    
    var ref: FIRDatabaseReference
    var uid: String
    var senderDisplayName: String
    var senderUID: String
    var lastUpdate: String
    var type: String
    var text: String
    
    init(senderUID: String, senderDisplayName: String, type: String, text: String){
        ref = DatabaseReference.messages.reference().childByAutoId()
        uid = ref.key
        self.senderDisplayName = senderDisplayName
        self.senderUID = senderUID
        self.type = type
        self.text = text
        self.lastUpdate = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
    }
    
    init(dictionary: [String: Any]){
        uid = dictionary["uid"] as! String
        ref = DatabaseReference.messages.reference().child(uid)
        senderDisplayName = dictionary["senderDisplayName"] as! String
        senderUID = dictionary["senderUID"] as! String
        lastUpdate = dictionary["lastUpdate"] as! String
        type = dictionary["type"] as! String
        text = dictionary["text"] as! String
    }
    
    
    func save(){
        ref.setValue(toDictionary())
    }
    

    func toDictionary() -> [String: Any] {
        return [
            "uid"  : uid,
            "senderDisplayName" : senderDisplayName,
            "senderUID" : senderUID,
            "lastUpdate" : lastUpdate,
            "type"  : type,
            "text"  : text
        
        
        ]
    }


}

extension Message: Equatable {}

func ==(lhs: Message, rhs: Message)->Bool{
    return lhs.uid == rhs.uid
}
