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


class DataStore {
    
    static let sharedInstance = DataStore()
    
    var currentUser: User?
    
    var currentDime: Dime?
    
    var cache = SAMCache.shared()
    

    func getCurrentDime(){
        
        if let dimes = currentUser?.dimes{
            if dimes.count > 0{
            currentUser?.dimes = sortByMostRecentlyCreated(dimes)
            let lastDimeCreatedTime = dimes.first?.createdTime
            if self.isDimeWithinOneDay(videoDate: lastDimeCreatedTime!){
                self.currentDime = dimes.first
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

    

}
