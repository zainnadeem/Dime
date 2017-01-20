//
//  FirebaseReference.swift
//  Moments
//
//  Created by Zain Nadeem on 10/29/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

//Create to ENUMS TO GENERATE references to firebase database

import Foundation
import Firebase

enum DatabaseReference {
    
    case root
    case users(uid: String)
    case allUsers
    case media     // posts 
    case dimes
    case chats
    case messages
    
    // MARK: - Public
    
    func reference() -> FIRDatabaseReference {
        return rootRef.child(path)
        
    }
    
    private var rootRef: FIRDatabaseReference{
        return FIRDatabase.database().reference()
    }
    
    private var path: String{
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        case .allUsers:
            return "users"
        case .media:
            return "media"
        case .chats:
            return "chats"
        case .dimes:
            return "dimes"
        case .messages:
            return "messages"
            
            
        }
    }
}


enum StorageReference {
    case root
    case images //for post
    case videos 
    case profileImages //for user
    
    func reference() -> FIRStorageReference{
       return baseRef.child(path)
    }
    
    private var baseRef: FIRStorageReference {
        return FIRStorage.storage().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .videos:
            return "videos"
        case .images:
            return "images"
        case .profileImages:
            return "profileImages"
        }
    }
}
