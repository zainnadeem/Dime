//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit
import NVActivityIndicatorView
import SAMCache
import Firebase

class MediaCollectionViewController: UICollectionViewController, UIGestureRecognizerDelegate
{
    lazy var videoURL:              String        = String()
    lazy var existingDime:          Bool          = Bool()
    lazy var selectedIndexPath:     Int           = Int()
    lazy var finishedEditing:       Bool          = Bool()
    
    var coverPhoto:            UIImage?
    
    var store = DataStore.sharedInstance
    var mediaPickerHelper: MediaPickerHelper?
    var passedDime: Dime!
    var dime: Dime?
    var draftDime: Dime?
    var newMedia: Media?
    
    let activityData = ActivityData()
    var cache = SAMCache.shared()
    
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "editIcon"), leftButtonImage: #imageLiteral(resourceName: "icon-home"), middleButtonImage: nil)
    
    
    struct Storyboard {
        static let mediaCell = "mediaCell"
        static let sectionHeader = "SectionHeader"
        static let sectionFooter = "SectionFooter"
        
        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 3.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    
    
    func dimePostAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: {
            action in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBarVC = storyboard.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
            tabBarVC.selectedIndex = 2
            tabBarVC.navigationController?.setNavigationBarHidden(true, animated: true)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let transition = CATransition()
            transition.type = kCATransitionFade
            appDelegate.window!.setRootViewController(tabBarVC, transition: transition)
        })
        
        alertVC.addAction(action)
        
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        if finishedEditing {
            
            dime?.createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
            store.currentDime = dime
            
            guard let currentDime = dime else{  print("NO CURRENT DIME")
                return }
            
            self.dimePostAlert(title: "Nice...", message: "Your Dime is uploading", buttonTitle: "Okay")
            
            var coverImage: UIImage = UIImage()
            
            
            if let photo = coverPhoto{
                coverImage = photo
            }else{
                coverImage = currentDime.media[0].mediaImage
            }
            
            
            let firImage = FIRImage(image: coverImage)
            firImage.save("\(currentDime.uid)-coverImage", completion: { error in
                self.cache?.setObject(coverImage, forKey: "\(currentDime.uid)-coverImage")
            })
            
            
            currentDime.updateOrCreateDime(completion: { (error) in
                
                
            })
            
            
        }else{
            alert(title: "Edit Your Photos", message: "Hit the edit button in the top right corner. Once you've edited your photos you can post your Dime!", buttonTitle: "Okay")
        }
    }
    
    @IBAction func changeCoverPhoto(_ sender: Any) {
        
    }
    
    @IBAction func homeButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navBar.delegate = self
        self.view.addSubview(navBar)
        
        
        
        dime = self.store.currentDime
        
        if let currentDime = dime {
            currentDime.media = sortByOrderCreated(currentDime.media)
        }
        
        draftDime = self.store.currentDime

        let bgImage = UIImageView()
        bgImage.image = #imageLiteral(resourceName: "background_GREY")
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
        
        let lpgr : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        lpgr.delegate = self
        lpgr.delaysTouchesBegan = true
        self.collectionView?.addGestureRecognizer(lpgr)
        
        installsStandardGestureForInteractiveMovement = true
    }
    
    func populateDime(){
        if UserDefaults.standard.bool(forKey: "hasUnpostedDime"){
            
        }
    }
    
    
    
    func getCoverPhoto(){
        guard let currentDime = self.dime else { return }
        let mediaImageKey = "\(currentDime.uid)-\(currentDime.createdTime)-coverImage"
        
        if let image = cache?.object(forKey: mediaImageKey) as? UIImage
        {
            self.coverPhoto = image
        }else {
            
            currentDime.downloadCoverImage(coverPhoto: mediaImageKey, completion: {  [weak self] (image, error)in
                self?.coverPhoto = image!
                self?.cache?.setObject(image, forKey: mediaImageKey)
            })
        }
        
    }
    
    
    
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizerState.began {
            return
        }
        
        let point = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if let index = indexPath {
            var cell = self.collectionView?.cellForItem(at: index)
            
            print(index.row)
            
            deleteMediaAlert(mediaNumber: index.row)
        } else {
            print("Could not find index path")
        }
    }
    
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if (dime?.media.count)! > 3 {
            self.performSegue(withIdentifier: "showEditView", sender: nil)
        } else {
            alert(title: "Oops!", message: "Please select at least four items to edit", buttonTitle: "Got it!")
        }
        
    }
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if dime?.media.count == 9 {
            return 9
        }else{
            return (dime?.media.count)! + 1
            
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaCollectionViewCell
        
        
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = true
        cell.mediaImageView.image = #imageLiteral(resourceName: "PLUS")
        if (dime?.media.count)! - 1 >= indexPath.row{
            cell.mediaImageView.image = dime?.media[indexPath.row].mediaImage
        }
        
        
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 1
        cell.imageLabel.text = ""
        cell.visualEffectView.isHidden = true
        
        return cell
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
            
            headerView.sectionTitleLabel.text = "Girls Night Out!"
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as! SectionFooterCollectionReusableView
            
            
            footerView.coverPhotoImage.image = coverPhoto
            if footerView.coverPhotoImage.image != nil {
                footerView.coverLabel.text = ""
            }
            
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        
        let defaultView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as! SectionFooterCollectionReusableView
        
        return defaultView
    }
    
    
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            if let dime = self.store.currentDime{
                
                if let videoURL = mediaObject as? URL {
                    self.newMedia = Media(dimeUID: dime.uid, type: "video", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: createThumbnailForVideo(path: videoURL.path), likesCount: 0, superLikesCount: 0)
                    
                    self.store.currentUser?.updateMediaCount(.increment, amount: 1)
                    
                    if let media = self.newMedia{
                        let videoData = NSData(contentsOf: videoURL as URL)
                        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                        let dataPath = NSTemporaryDirectory().appendingPathComponent("/\(media.uid).mp4")
                        videoData?.write(toFile: dataPath, atomically: false)
                        
                        media.mediaURL = dataPath
                        
                        //                        UserDefaults.standard.set(videoData, forKey: "\(indexPath.row)Video")
                        //                        UserDefaults.standard.set(createThumbnailForVideo(path: videoURL.path), forKey: "\(indexPath.row)Image")
                        //                        UserDefaults.standard.set(true, forKey: "\(indexPath.row)")
                        //                        UserDefaults.standard.synchronize()
                        
                    }
                } else if let snapshotImage = mediaObject as? UIImage {
                    
                    self.newMedia = Media(dimeUID: dime.uid, type: "photo", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: snapshotImage, likesCount: 0, superLikesCount: 0)
                    self.store.currentUser?.updateMediaCount(.increment, amount: 1)
                    //
                    //                        UserDefaults.standard.set(UIImagePNGRepresentation(snapshotImage), forKey: "\(indexPath.row)")
                    //                        UserDefaults.standard.set(true, forKey: "\(indexPath.row)")
                    //                        UserDefaults.standard.synchronize()
                    
                }
                
                if let media = self.newMedia {
                    
                    if (dime.media.count) >= indexPath.row + 1 { dime.media.remove(at: indexPath.row) }
                    dime.media.insert(media, at: indexPath.row)
                    
                    
                    
                    collectionView.reloadData()
                    
                }
                
                self.newMedia = nil
            }
        })
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditView" {
            store.currentDime = dime
            let destinationVC = segue.destination as! UINavigationController
            let targetController = destinationVC.topViewController as! EditingViewController
            targetController.mediaCollectionViewController = self
            targetController.passedDime = store.currentDime
        }
    }
    
    func deleteMediaAlert(mediaNumber: Int){
        guard let currentDime = self.dime else {return }
        
        let actionSheet = UIAlertController(title: "Delete", message: "All information for this image will be lost", preferredStyle: .actionSheet)
        
        let selectCover = UIAlertAction(title: "make cover photo", style: .default, handler: {
            action in
            
            self.coverPhoto = currentDime.media[mediaNumber].mediaImage
            self.collectionView?.reloadData()
            
        })
        
        
        
        
        let delete = UIAlertAction(title: "delete", style: .default, handler: {
            action in
            
            currentDime.media[mediaNumber].deleteMediaFromFireBase()
            if (currentDime.media.count) >= mediaNumber + 1 { currentDime.media.remove(at: mediaNumber) }
            self.store.currentUser?.updateMediaCount(.decrement, amount: 1)
            
            if currentDime.media.count == 0{
                currentDime.deleteDimeFromFireBase()
                self.store.currentDime = nil
                self.dismiss(animated: true, completion: {
                    self.store.getCurrentDime()
                })
            }
            
            self.collectionView?.reloadData()
            
        })
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: {
            action in
            print("Cancel pressed")
        })
        
        
        actionSheet.addAction(selectCover)
        actionSheet.addAction(delete)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    
}


extension MediaCollectionViewController {
    
    func alert(title: String, message: String, buttonTitle: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
}




extension MediaCollectionViewController : NavBarViewDelegate {
    
    func rightBarButtonTapped(_ sender: AnyObject) {
        if (dime?.media.count)! > 3 {
            self.performSegue(withIdentifier: "showEditView", sender: nil)
        } else {
            alert(title: "Oops!", message: "Please select at least four items to edit", buttonTitle: "Got it!")
        }
        print("Not sure what the right bar button will do yet.")
    }
    
    func leftBarButtonTapped(_ sender: AnyObject) {
        let alertVC = UIAlertController(title: "Unsaved Changes", message: "You have not posted your dime, unsaved images will be lost.", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "okay", style: .default, handler: {
            action in
            
            self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
            
        })
        
        let draft = UIAlertAction(title: "save draft", style: .default) { (action) in
            self.draftDime?.createdTime = Constants.dateFormatter().string(from: Date(timeIntervalSinceNow: 0))
            self.store.currentDime = self.draftDime
            
            var coverImage: UIImage = UIImage()
            
            if let photo = self.coverPhoto{
                coverImage = photo
            } else if let image = self.draftDime?.media[0].mediaImage {
                coverImage = image
            }
            
            let firImage = FIRImage(image: coverImage)
            firImage.save("\(self.draftDime?.uid)-coverImage", completion: { error in
                self.cache?.setObject(coverImage, forKey: "\(self.draftDime?.uid)-coverImage")
            })
            
            self.draftDime?.updateOrCreateDraft(completion: { (error) in
            })
            
            self.dimePostAlert(title: "Great!", message: "Draft Saved", buttonTitle: "Okay")
            
        }
        
        let cancel = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(action)
        alertVC.addAction(draft)
        alertVC.addAction(cancel)
        
        present(alertVC, animated: true, completion: nil)
        
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}



















