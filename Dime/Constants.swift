//
//  Constants.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit


extension UIFont {
    class func dimeFont(_ size : CGFloat) -> UIFont {
        return UIFont(name: "Avenir", size: size)!
    }
    
    class func dimeFontBold(_ size : CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Black", size: size)!
    }
    
    class func dimeFontItalic(_ size : CGFloat) -> UIFont {
        return UIFont(name: "Avenir-MediumOblique", size: size)!
    }

    

}

extension UIColor {
    class func dimeLightBlue() -> UIColor {
        return UIColor(red: 95.0/255.0, green: 146.0/255.0, blue: 170.0/255.0, alpha: 1.0)
    }
    
    class func dimeLightYellow() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 176.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    class func dimeLightRed() -> UIColor {
        return UIColor(red: 196.0/255.0, green: 119.0/255.0, blue: 110.0/255.0, alpha: 1.0)
    }
        
    
    
    
    // SideMenuGrayColor
    class func sideMenuGrey() -> UIColor {
        return UIColor(red:  19/255, green: 22/255, blue: 29/255, alpha: 0.4)
        
    }
    
    func colorCode() -> UInt {
        
        var red : CGFloat = 0, green : CGFloat = 0, blue : CGFloat = 0
        
        if self.getRed(&red, green: &green, blue: &blue, alpha: nil) {
            let redInt = UInt(red * 255 + 0.5)
            let greenInt = UInt(green * 255 + 0.5)
            let blueInt = UInt(blue * 255 + 0.5)
            
            return (redInt << 16) | (greenInt << 8) | blueInt
        }
        
        return 0
    }
}

class Constants {
    
    class func twoHoursAgo() -> Date {
        return Constants.dateFormatter().date(from: Constants.twoHoursAgo())!
    }
    
    class func twoHoursAgo() -> String {
        return Constants.dateFormatter().string(from: Date(timeInterval: -7200, since: Date(timeIntervalSinceNow: 0)))
    }
    
    class func oneDayAgo() -> String {
        return Constants.dateFormatter().string(from: Date(timeInterval: -86400, since: Date(timeIntervalSinceNow: 0)))
    }
    
    class func displayAlert(_ title: String, message: String) -> UIAlertController {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        return alert
        
    }
    
    class func dateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M/d/yy, HH:mm:ss"
        return dateFormatter
    }
    
    class func timeRemainingForDeal(_ date: Date) -> String {
        
        let twoHoursFromDate = date.addingTimeInterval(7200)
        let now = Date(timeIntervalSinceNow: 0)
        let secondsRemaining = twoHoursFromDate.timeIntervalSince(now)
        let minutesRemaining = secondsRemaining / 60
        
        if minutesRemaining == 120 {
            let minuteString = Int(minutesRemaining)
            return "Expires in \(minuteString) hrs"
        }
        else if minutesRemaining > 59.9 && minutesRemaining < 61 {
            let minuteString = Int(minutesRemaining)
            return "Expires in 1 hr"
        }
        else if minutesRemaining >= 61 && minutesRemaining < 120 {
            let minuteString = Int(minutesRemaining - 60)
            return "Expires in 1 hr \(minuteString) min"
        } else if minutesRemaining < 60 && minutesRemaining > 0 {
            let minuteString = Int(minutesRemaining)
            return "Expires in \(minuteString) min"
        } else {
            return "Expired"
        }
    }
    

}
