////
////  User.swift
////  Dime
////
////  Created by Zain Nadeem on 11/7/16.
////  Copyright © 2016 Zain Nadeem. All rights reserved.
////
//
//import Foundation
//
//class User {
//    
//    var uid             : String
//    var username        : String
//    var firstName       : String
//    var lastName        : String
//    var email           : String
//    var profilePicURL   : String
//    var dateCreated     : String
//    var city            : String
//    var deviceToken     : String
//    
//    var followingUsers        : [String : String]
//    var followedByUsers       : [String : String]
//    var blockedUsers          : [String : String]
//    
//    var dimesAlbums           : [[String : AnyObject]]
//    
//    init(withUsername username : String, emailAddress : String, uid : String) {
//        
//        self.username = username
//        self.email = emailAddress
//        self.dateCreated = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
//        self.uid = uid
//        
//        self.tagline = ""
//        self.locationText = ""
//        self.storeHours = ""
//        self.website = ""
//        self.phoneNumber = ""
//        self.tags = [""]
//        self.cumulativeViews = 0
//        self.cumulativeRoars = 0
//        self.profilePicture = ""
//        
//        self.latestVideo = ["url" : "" as AnyObject,
//                            "dealName" : "" as AnyObject,
//                            "numRedeemable": 0 as AnyObject,
//                            "numRedeemed" : 0 as AnyObject,
//                            "text" : "" as AnyObject,
//                            "dateCreated" : "" as AnyObject,
//                            "views" : 0 as AnyObject,
//                            "roars" : 0 as AnyObject,
//                            "redeemed by" : [""] as AnyObject]
//        
//        self.videos =     [["url" : "" as AnyObject,
//                            "dealName" : "" as AnyObject,
//                            "numRedeemable": 0 as AnyObject,
//                            "numRedeemed" : 0 as AnyObject,
//                            "text" : "" as AnyObject,
//                            "dateCreated" : "" as AnyObject,
//                            "views" : 0 as AnyObject,
//                            "roars" : 0 as AnyObject,
//                            "redeemed by" : [""] as AnyObject]]
//    }
//    
//}
