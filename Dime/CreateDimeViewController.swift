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
    
    var cache = SAMCache.shared()
    let store = DataStore.sharedInstance
    var mediaPickerHelper: MediaPickerHelper!
    
    lazy var passedImage:               UIImage     =   UIImage()
    lazy var image:                     UIImage     =   UIImage()

    lazy var dimeTitleLabel:            UILabel     =   UILabel()
    lazy var dimeCoverPhoto:            UIButton    =   UIButton()
    lazy var numberOfImages:            UILabel     =   UILabel()
    lazy var timeLeftToPostLabel:       UILabel     =   UILabel()
    lazy var createNewDimeButton:       UIButton    =   UIButton()
    lazy var editCurrentDimeButton:     UIButton    =   UIButton()
    lazy var expiringLabel:             UILabel     =   UILabel()
    
    var videoURL:                  URL?
    
    let textFieldlimitLength                        = 30

    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: nil, leftButtonImage: #imageLiteral(resourceName: "icon-home"), middleButtonImage: nil)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = #imageLiteral(resourceName: "background_GREY")
        self.view.insertSubview(backgroundImage, at: 0)
        
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        self.setViewConstraints()

        
        updateDimeInfo()
        self.store.getImages { 
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.store.currentDime == nil {
            self.editCurrentDimeButton.isEnabled = false
            self.createNewDimeButton.isEnabled = false
            
            self.editCurrentDimeButton.isHidden = true
            self.createNewDimeButton.isHidden = true
            
            self.expiringLabel.isHidden = true
            
            self.dimeTitleLabel.text = "Get Started!"
            self.dimeCoverPhoto.setImage(#imageLiteral(resourceName: "NoDimeImage"), for: .normal)
            self.dimeCoverPhoto.imageView?.contentMode = .scaleAspectFit
            
            self.dimeCoverPhoto.removeTarget(self, action: #selector(EditCurrentDimeTapped), for: .touchUpInside)
            self.dimeCoverPhoto.addTarget(self, action: #selector(createNewDimeButtonTapped), for: .touchUpInside)
        
        }else{
            
            self.editCurrentDimeButton.isEnabled = true
            self.createNewDimeButton.isEnabled = true
           
            self.editCurrentDimeButton.isHidden = false
            self.createNewDimeButton.isHidden = false
            
            self.expiringLabel.isHidden = false
            
            self.dimeCoverPhoto.removeTarget(self, action: #selector(createNewDimeButtonTapped), for: .touchUpInside)
            self.dimeCoverPhoto.addTarget(self, action: #selector(EditCurrentDimeTapped), for: .touchUpInside)
            
            self.dimeCoverPhoto.imageView?.contentMode = .scaleAspectFit

        }
    }
    
    
    func setViewConstraints(){
        
        self.view.addSubview(dimeTitleLabel)
        self.dimeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.dimeTitleLabel.topAnchor.constraint(equalTo: self.navBar.bottomAnchor, constant: 30).isActive = true
        self.dimeTitleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.dimeTitleLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.dimeTitleLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        self.dimeTitleLabel.textAlignment = .center
        self.dimeTitleLabel.textColor = UIColor.black
        self.dimeTitleLabel.font = UIFont.dimeFontBold(20)
        
        
        self.view.addSubview(dimeCoverPhoto)
        dimeCoverPhoto.imageView?.clipsToBounds = true
        self.dimeCoverPhoto.translatesAutoresizingMaskIntoConstraints = false
        self.dimeCoverPhoto.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.dimeCoverPhoto.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.dimeCoverPhoto.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.4).isActive = true
        self.dimeCoverPhoto.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        self.dimeCoverPhoto.addTarget(self, action: #selector(EditCurrentDimeTapped), for: .touchUpInside)
        
        self.view.addSubview(expiringLabel)
        self.expiringLabel.translatesAutoresizingMaskIntoConstraints = false
        self.expiringLabel.topAnchor.constraint(equalTo: self.dimeCoverPhoto.bottomAnchor, constant: 5).isActive = true
        self.expiringLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.expiringLabel.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.05).isActive = true
        self.expiringLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        self.expiringLabel.textAlignment = .center
        self.expiringLabel.textColor = UIColor.red
        self.expiringLabel.font = UIFont.dimeFontBold(12)
        
        

        self.view.addSubview(editCurrentDimeButton)
        self.editCurrentDimeButton.translatesAutoresizingMaskIntoConstraints = false
        self.editCurrentDimeButton.topAnchor.constraint(equalTo: self.expiringLabel.bottomAnchor, constant: 5).isActive
            = true
        self.editCurrentDimeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.editCurrentDimeButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        self.editCurrentDimeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        //self.editCurrentDimeButton.backgroundColor = UIColor.black
        self.editCurrentDimeButton.setTitle("Edit Current Dime", for: UIControlState())
        self.editCurrentDimeButton.titleLabel?.font = UIFont.dimeFontBold(14)
        self.editCurrentDimeButton.titleLabel?.textColor = UIColor.white
        
        self.editCurrentDimeButton.addTarget(self, action: #selector(EditCurrentDimeTapped), for: .touchUpInside)
        

        self.view.addSubview(createNewDimeButton)
        self.createNewDimeButton.translatesAutoresizingMaskIntoConstraints = false
        self.createNewDimeButton.topAnchor.constraint(equalTo: self.editCurrentDimeButton.bottomAnchor, constant: 15).isActive
            = true
        self.createNewDimeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.createNewDimeButton.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.07).isActive = true
        
        self.createNewDimeButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.75).isActive = true
        self.createNewDimeButton.backgroundColor = UIColor.white
        self.createNewDimeButton.setTitle("CreateNewDime", for: UIControlState())
        self.createNewDimeButton.titleLabel?.font = UIFont.dimeFontBold(14)
        self.createNewDimeButton.setTitleColor(UIColor.black, for: UIControlState())
        createNewDimeButton.layer.cornerRadius = 10
        
        self.createNewDimeButton.addTarget(self, action: #selector(createNewDimeButtonTapped), for: .touchUpInside)
        
        
    }
    
    
    func EditCurrentDimeTapped() {
   
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
        controller.finishedEditing = true
        controller.coverPhoto = dimeCoverPhoto.imageView?.image
        self.present(controller, animated: true, completion: nil)
    }

    
    func alert(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler:{ action in
            self.dismiss(animated: true, completion: nil)
        }))
        
        alertVC.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.startNewDimeCreation()
        }))
        present(alertVC, animated: true, completion: nil)
    }

    
    
    
    
    func createNewDimeButtonTapped() {
        
        if store.currentDime != nil {
            self.alert(title: "You are creating a new dime", message: "changes to your current dime can no longer be made")
        }else{
            startNewDimeCreation()
        }
        
        
    }
    
    func startNewDimeCreation(){
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
       
            if let videoURL = mediaObject as? URL {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
                let newDime = Dime(caption: "", createdBy: self.store.currentUser!, media: [], totalDimeLikes: 0, averageLikesCount: 0, totalDimeSuperLikes: 0)
                self.store.currentDime = newDime
                
                let newMedia = Media(dimeUID: newDime.uid, type: "video", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: createThumbnailForVideo(path: videoURL.path), likesCount: 0, superLikesCount: 0)
                let videoData = NSData(contentsOf: videoURL as URL)
                
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                let dataPath = NSTemporaryDirectory().appendingPathComponent("/\(newMedia.uid).mp4")
                videoData?.write(toFile: dataPath, atomically: false)
                
                newMedia.mediaURL = dataPath
                
                self.store.currentDime?.media.append(newMedia)
                self.store.currentUser?.updateMediaCount(.increment, amount: 1)
                self.present(controller, animated: true, completion: nil)
                
            } else if let snapshotImage = mediaObject as? UIImage {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
                let newDime = Dime(caption: "", createdBy: self.store.currentUser!, media: [], totalDimeLikes: 0, averageLikesCount: 0, totalDimeSuperLikes: 0)
                self.store.currentDime = newDime
                
                self.image = snapshotImage
                let newMedia = Media(dimeUID: newDime.uid, type: "photo", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: self.image, likesCount: 0, superLikesCount: 0)
                self.store.currentDime?.media.append(newMedia)
                self.store.currentUser?.updateMediaCount(.increment, amount: 1)
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
            
            
            if self.store.currentDime?.caption == ""{
                self.dimeTitleLabel.text = "Title"
            }else{
                self.dimeTitleLabel.text = self.store.currentDime?.caption
            }
            
            self.expiringLabel.text = Constants.timeRemainingForDime(date!)
            
            
            if self.timeLeftToPostLabel.text == "Expired"{
                self.dimeCoverPhoto.isEnabled = false
            }else{
                self.dimeCoverPhoto.isEnabled = true
            }
            guard let currentDime = self.store.currentDime else { print("no current dime")
                return }
            self.numberOfImages.text = self.store.currentDime?.media.count.description
            
            
            
            
            let mediaImageKey = "\(currentDime.uid)-coverImage"
            
            if let image = cache?.object(forKey: mediaImageKey) as? UIImage
            {
                dimeCoverPhoto.setImage(image, for: .normal)
            
            }else {
                
                self.store.currentDime?.downloadCoverImage(coverPhoto: mediaImageKey, completion: {  [weak self] (image, error)in
                    self?.dimeCoverPhoto.setImage(image, for: .normal)
                    self?.cache?.setObject(image, forKey: mediaImageKey)
                })

            }
            self.dimeCoverPhoto.imageView?.contentMode = .scaleAspectFit
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= textFieldlimitLength // Bool
        
    }
    
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

