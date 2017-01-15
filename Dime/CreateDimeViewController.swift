//
//  CreateDimeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/29/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import SAMCache

class CreateDimeViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var mediaPickerHelper: MediaPickerHelper!
    var passedImage: UIImage = UIImage()
    var image: UIImage?
    var videoURL: URL?
    var cache = SAMCache.shared()
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "icon-home"), middleButtonImage: nil)

    @IBOutlet weak var dimeTitleTextField: UITextField!
    @IBOutlet weak var dimeCoverPhoto: UIButton!
    @IBOutlet weak var numberOfImages: UILabel!
    @IBOutlet weak var timeLeftToPostLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        dimeCoverPhoto.isEnabled = false
        updateDimeInfo()
        self.store.getImages { 
            
        }
    }
    
    @IBAction func dimeCoverPhotoTapped(_ sender: Any) {
   
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
        controller.finishedEditing = true
        controller.coverPhoto = dimeCoverPhoto.imageView?.image
        self.present(controller, animated: true, completion: nil)
    }

    
    func alert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertVC.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.startNewDimeCreation()
        }))
        present(alertVC, animated: true, completion: nil)
    }

    
    @IBAction func centerCameraTapped(_ sender: Any) {
        
        if store.currentDime != nil {
            self.alert(title: "New Dime", message: "changes to your current dime can no longer be made")
        }else{
            startNewDimeCreation()
        }
        
        
    }
    
    func startNewDimeCreation(){
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
            
            let newDime = Dime(caption: "", createdBy: self.store.currentUser!, media: [], totalLikes: 0, averageLikesCount: 0, totalSuperLikes: 0)
            
            self.store.currentDime = newDime
            
            if let videoURL = mediaObject as? URL {
                
                let newMedia = Media(dimeUID: newDime.uid, type: "video", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: createThumbnailForVideo(path: videoURL.path), likesCount: 0, superLikesCount: 0)
                let videoData = NSData(contentsOf: videoURL as URL)
                
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                let dataPath = NSTemporaryDirectory().appendingPathComponent("/\(newMedia.uid).mp4")
                videoData?.write(toFile: dataPath, atomically: false)
                
                newMedia.mediaURL = dataPath
                
                self.store.currentDime?.media.append(newMedia)
                self.present(controller, animated: true, completion: nil)
                
            } else if let snapshotImage = mediaObject as? UIImage {
                
                self.image = snapshotImage
                let newMedia = Media(dimeUID: newDime.uid, type: "photo", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: self.image!, likesCount: 0, superLikesCount: 0)
                self.store.currentDime?.media.append(newMedia)
                controller.finishedEditing = false
                self.present(controller, animated: true, completion: nil)
                
            }
            
        })
        
    }
    
    func updateDimeInfo(){
        if self.store.currentDime != nil {
            store.getCurrentDime()
            let dateCurrentDimeWasCreated = self.store.currentDime?.createdTime
            let date = Constants.dateFormatter().date(from: dateCurrentDimeWasCreated!)
            self.timeLeftToPostLabel.text = Constants.timeRemainingForDime(date!)
            if self.timeLeftToPostLabel.text == "Expired"{
                self.dimeCoverPhoto.isEnabled = false
            }else{
                self.dimeCoverPhoto.isEnabled = true
            }
            guard let currentDime = self.store.currentDime else { print("no current dime")
                return }
            self.numberOfImages.text = self.store.currentDime?.media.count.description
            
            let mediaImageKey = "\(currentDime.uid)-\(currentDime.createdTime)-coverImage"
            
            if let image = cache?.object(forKey: mediaImageKey) as? UIImage
            {
                dimeCoverPhoto.setImage(image, for: .normal)
            }else {
                
                self.store.currentDime?.downloadCoverImage(coverPhoto: mediaImageKey, completion: {  [weak self] (image, error)in
                    self?.dimeCoverPhoto.setImage(image, for: .normal)
                    self?.cache?.setObject(image, forKey: mediaImageKey)
                })

            }
         
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mediaCollectionSegue" {
            let destinationVC = segue.destination as! MediaCollectionViewController
            destinationVC.coverPhoto = dimeCoverPhoto.imageView?.image
            destinationVC.passedDime = store.currentDime
        }
    }
    
    
}

extension CreateDimeViewController: UITextFieldDelegate {
    
    
}

extension CreateDimeViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}

//media thumbnail

