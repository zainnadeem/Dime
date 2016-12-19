//
//  FIRVideo.swift
//  Dime
//
//  Created by Zain Nadeem on 01/12/2016.
//  Copyright © 2016 Anton Novoselov. All rights reserved.
//

import Foundation
import Firebase

class FIRVideo {
    
    var ref: FIRStorageReference!
    var downloadLink: String!
    
    // MARK: - PROPERTIES
    var videoURL: URL
    
    // MARK: - INITIALILZERS
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    // MARK: - SAVE METHOD
    func saveToFirebaseStorage(uid: String, completion: @escaping (FIRStorageMetadata?, Error?) -> Void) {
       // let videoUid = NSUUID().uuidString
        ref = StorageReference.videos.reference().child(uid)
        ref.putFile(self.videoURL, metadata: nil, completion: { meta, error in
            completion(meta, error)
        })
    }
    
    
    func save(_ uid:String, completion: @escaping (FIRStorageMetadata?, Error?) -> Void) {
    
        ref = StorageReference.videos.reference().child(uid)
       
        
        ref.putFile(self.videoURL, metadata: nil, completion: { meta, error in
            completion(meta, error)
        })
}
}


