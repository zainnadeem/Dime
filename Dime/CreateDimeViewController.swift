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

class CreateDimeViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var mediaPickerHelper: MediaPickerHelper!
    var passedImage: UIImage = UIImage()
    var image: UIImage?
    var videoURL: URL?
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "icon-home"), leftButtonImage: #imageLiteral(resourceName: "icon-inbox"), middleButtonImage: #imageLiteral(resourceName: "icon-inbox"))

    @IBOutlet weak var dimeTitleTextField: UITextField!
    @IBOutlet weak var dimeCoverPhoto: UIButton!
    @IBOutlet weak var numberOfImages: UILabel!
    @IBOutlet weak var timeLeftToPostLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.delegate = self
        self.view.addSubview(navBar)

    }

    
    @IBAction func centerCameraTapped(_ sender: Any) {
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            let newDime = Dime(caption: "New One", createdBy: self.store.currentUser!, media: [])
            self.store.currentDime = newDime
            
            if let videoURL = mediaObject as? URL {
               
                let videoData = NSData(contentsOf: videoURL as URL)
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                
                let dataPath = NSTemporaryDirectory().appendingPathComponent("/\(newDime.uid).mp4")
                videoData?.write(toFile: dataPath, atomically: false)
                
                let newMedia = Media(dimeUID: newDime.uid, type: "video", caption: "", createdBy: self.store.currentUser!, mediaURL: dataPath, location: "", mediaImage: createThumbnailForVideo(path: videoURL.path))
                self.store.currentDime?.media.append(newMedia)
                
                
            } else if let snapshotImage = mediaObject as? UIImage {
                
                self.image = snapshotImage
                let newMedia = Media(dimeUID: newDime.uid, type: "photo", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: self.image!)
                self.store.currentDime?.media.append(newMedia)
                
                
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
            
            self.present(controller, animated: true, completion: nil)
            
        })
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mediaCollectionSegue" {
            let destinationVC = segue.destination as! MediaCollectionViewController
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

