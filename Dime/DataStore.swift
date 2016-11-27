//
//  Datastore.swift
//  Dime
//
//  Created by Zain Nadeem on 11/5/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation


class DataStore {
    
    static let sharedInstance = DataStore()
    
    var currentUser: User?
    
    var currentDime: Dime?
//    
//    
//    func createDummyDimeMedia () {
//        let dimeMedia1 = DimeMedia(photoURL: "t1", dateCreated: "OCT 5", likes: "1", likedBy: ["Chuck", "Joe"], caption: "It was the best of times it was the worst of times")
//        let dimeMedia2 = DimeMedia(photoURL: "t2", dateCreated: "OCT 6", likes: "2", likedBy: ["Chuck", "Joe", "Sam"], caption: "It was the best of times in my face is good")
//        let dimeMedia3 = DimeMedia(photoURL: "t3", dateCreated: "OCT 7", likes: "3", likedBy: ["Chuck", "Joe", "Oliver"], caption: " was the worst of times")
//        let dimeMedia4 = DimeMedia(photoURL: "t5", dateCreated: "OCT 8", likes: "4", likedBy: ["Oliver", "Joe"], caption: "It was the best Time")
//        
//        let firstDimeAlbum = DimeAlbum(media: [dimeMedia1, dimeMedia2, dimeMedia3, dimeMedia4, dimeMedia1, dimeMedia2, dimeMedia3, dimeMedia4, dimeMedia4], mainDimePhoto: dimeMedia3, dateCreated: "10.25.16", likes: "89", likedBy: ["Lisa, Alice, Jason"], caption: "First Dime album what do you guys think")
//        
//        self.currentDime = firstDimeAlbum
//
//    }

}
