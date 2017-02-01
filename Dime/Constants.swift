//
//  Constants.swift
//  Dime
//
//  Created by Zain Nadeem on 12/6/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

var borderWidth            : CGFloat       = 3.0
var profileImageHeightMultiplier : CGFloat =      (0.75)
var tabBarHeight                : CGFloat = 49

public struct Storyboard {
    static let showWelcome = "ShowWelcomeViewController"
    static let postComposerNVC = "PostComposerNavigationVC"
    
    static let mediaCell = "MediaCell"
    static let mediaHeaderCell = "MediaHeaderCell"
    static let searchUserCell = "SearchUserCell"
    static let mediaHeaderHeight: CGFloat = 57
    static let mediaCellDefaultHeight: CGFloat = 597
    
    static let showMediaDetailSegue = "ShowMediaDetailSegue"
    
    static let commentCell = "CommentCell"
    static let showCommentComposer = "ShowCommentComposer"
    static let showHomeSegue = "ShowHomeViewController"
    
}

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
    
    class func dimeDarkBlue() -> UIColor {
        return UIColor(red: 39.0/255.0, green: 108.0/255.0, blue: 141.0/255.0, alpha: 1.0)
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
    
    class func twoDaysAgo() -> String {
        return Constants.dateFormatter().string(from: Date(timeInterval: -176800, since: Date(timeIntervalSinceNow: 0)))
    }
    
    class func isDimeWithinTwoDays(videoDate date : String) -> Bool {
        if let creationDate = Constants.dateFormatter().date(from: date) {
            
            let yesterday = Constants.dateFormatter().date(from: Constants.twoDaysAgo())!
            
            if creationDate.compare(yesterday) == .orderedDescending { return true }
            else if creationDate.compare(yesterday) == .orderedSame  { return true }
            else { return false }
            
        } else {
            print("Couldn't get NSDate object from string date arguement")
            return false
        }
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
    
    class func timeRemainingForDime(_ date: Date) -> String {
        
        let twentyFourHoursFromDate = date.addingTimeInterval(86400)
        let now = Date(timeIntervalSinceNow: 0)
        let secondsRemaining = twentyFourHoursFromDate.timeIntervalSince(now)
        let minutesRemaining = secondsRemaining / 60
        
        if minutesRemaining > 120 {
            let minuteString = Int(minutesRemaining)
            return "Expires in \(minuteString / 60) hrs"
        }
        else if minutesRemaining > 59.9 && minutesRemaining < 61 {
            let minuteString = Int(minutesRemaining / 60)
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

extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/4, size.width/4)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: square))
        imageView.contentMode = .scaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

    
    func createThumbnailForVideo(path: String) -> UIImage{
        
        do {
            let asset = AVURLAsset(url: NSURL(fileURLWithPath: path) as URL, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
            return #imageLiteral(resourceName: "icon-camera-filled")
    }

extension String {
    func appendingPathComponent(_ string: String) -> String {
        return URL(fileURLWithPath: self).appendingPathComponent(string).path
    }
    
    
}

extension UINavigationController {
    
    public func pushViewController(viewController: UIViewController,
                                   animated: Bool,
                                   completion: (() -> Void)?) {
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        pushViewController(viewController, animated: animated)
        CATransaction.commit()
    }
    
}

extension UIWindow {
func setRootViewController(_ newRootViewController: UIViewController, transition: CATransition? = nil) {
    
    let previousViewController = rootViewController
    
    if let transition = transition {
        // Add the transition
        layer.add(transition, forKey: kCATransition)
    }
    
    rootViewController = newRootViewController
    
    // Update status bar appearance using the new view controllers appearance - animate if needed
    if UIView.areAnimationsEnabled {
        UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
            newRootViewController.setNeedsStatusBarAppearanceUpdate()
        })
    } else {
        newRootViewController.setNeedsStatusBarAppearanceUpdate()
    }
    
    /// The presenting view controllers view doesn't get removed from the window as its currently transistioning and presenting a view controller
    if let transitionViewClass = NSClassFromString("UITransitionView") {
        for subview in subviews where subview.isKind(of: transitionViewClass) {
            subview.removeFromSuperview()
        }
    }
    if let previousViewController = previousViewController {
        // Allow the view controller to be deallocated
        previousViewController.dismiss(animated: false) {
            // Remove the root view in case its still showing
            previousViewController.view.removeFromSuperview()
        }
    }
}
}



