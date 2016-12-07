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
