//
//  DimeMedia.swift
//  Dime
//
//  Created by Zain Nadeem on 11/5/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation

class DimeMedia {
    
    //dummyDataImage change to media URL
    var photoURL: String
    
    var dateCreated : String
    var likes : String
    var likedBy: [String] //should be a array of users
    var caption: String
    
    init(photoURL: String, dateCreated: String, likes : String, likedBy : [String], caption : String) {
        
        self.photoURL = photoURL
        self.dateCreated = dateCreated
        self.likes = likes
        self.likedBy = likedBy
        self.caption = caption
        
    }
    
    
}
