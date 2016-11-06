//
//  DimeAlbum.swift
//  
//
//  Created by Zain Nadeem on 11/5/16.
//
//

import Foundation

class DimeAlbum {
    
    //dummyDataImage change to media URL
    var media: [DimeMedia]
    var mainDimePhoto: DimeMedia
    var dateCreated: String
    var likedBy : [String]
    var likes : String //should be a array of users
    var caption: String

    
    init(media: [DimeMedia], mainDimePhoto: DimeMedia, dateCreated: String, likes : String, likedBy : [String], caption : String) {
        
        self.media = media
        self.mainDimePhoto = mainDimePhoto
        self.dateCreated = dateCreated
        self.likes = likes
        self.likedBy = likedBy
        self.caption = caption
        
    }
    
    
}
