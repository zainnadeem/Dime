//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit
import NVActivityIndicatorView

class MediaCollectionViewController: UICollectionViewController
{
    
    var store = DataStore.sharedInstance
    var selectedIndexPath: Int = Int()
    
    var mediaPickerHelper: MediaPickerHelper?
    var passedDime: Dime!
    
    var dime: Dime?
    var newMedia: Media?
    var videoURL: String = String()
    
    var existingDime: Bool = Bool()
    
    let activityData = ActivityData()
    
    
    lazy var navBar : NavBarView = NavBarView(withView: self.view, rightButtonImage: #imageLiteral(resourceName: "editIcon"), leftButtonImage: #imageLiteral(resourceName: "backArrow"), middleButtonImage: nil)

    var finishedEditing: Bool = Bool()
    
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
        let action = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func postButtonTapped(_ sender: Any) {
        store.currentDime = dime
        self.dimePostAlert(title: "Nice...", message: "Your Dime is uploading", buttonTitle: "Okay")
        self.store.currentDime?.saveToUser(saveToUser: store.currentUser!, completion: { (error) in
            self.store.getCurrentDime()
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                //NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
            }
            
        })
        
        store.currentDime?.save(completion: { (error) in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{

            }
        })
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
        
        let bgImage = UIImageView()
        bgImage.image = #imageLiteral(resourceName: "background_GREY")
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
        
        installsStandardGestureForInteractiveMovement = true
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
        
        
        if indexPath.row == 0 {
            cell.layer.borderColor =  UIColor.blue.cgColor
            cell.layer.borderWidth = 1
            cell.imageLabel.text = "Cover"
            cell.visualEffectView.isHidden = false
        }else{
            cell.layer.borderColor = UIColor.white.cgColor
            cell.layer.borderWidth = 1
            cell.imageLabel.text = ""
            cell.visualEffectView.isHidden = true
        }
        
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
            
            
  
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        mediaPickerHelper = MediaPickerHelper(viewController: self, completion: { (mediaObject) in
            
            if let dime = self.store.currentDime{
                
                if let videoURL = mediaObject as? URL {
                    self.newMedia = Media(dimeUID: dime.uid, type: "video", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: createThumbnailForVideo(path: videoURL.path))
                    
                    if let media = self.newMedia{
                        let videoData = NSData(contentsOf: videoURL as URL)
                        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
                        let dataPath = NSTemporaryDirectory().appendingPathComponent("/\(media.uid).mp4")
                        videoData?.write(toFile: dataPath, atomically: false)
                        
                        media.mediaURL = dataPath
                    }
                } else if let snapshotImage = mediaObject as? UIImage {
                    
                    self.newMedia = Media(dimeUID: dime.uid, type: "photo", caption: "", createdBy: self.store.currentUser!, mediaURL: "", location: "", mediaImage: snapshotImage)
                    
                }
                
                if let media = self.newMedia {
                    
                    if (dime.media.count) >= indexPath.row + 1 { dime.media.remove(at: indexPath.row) }
                    dime.media.insert(media, at: indexPath.row)
                    collectionView.reloadData()
                    
                }
                
            }
        })
    }
    

    
    override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        if indexPath.row == (collectionView.numberOfItems(inSection: 0) - 1) && (dime?.media.count)! < 9 && indexPath.section == 0{
            return false
        }
        
        return true
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        collectionView.reloadData()

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
        self.dismiss(animated: true, completion: nil)
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}



















