//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit

class MediaCollectionViewController: UICollectionViewController
{
    var store = DataStore.sharedInstance
    var selectedIndexPath: Int = Int()
    var imagePickerHelper: ImagePickerHelper?
    var imagesToEdit: [UIImage] = [UIImage]()
    
    
    struct Storyboard {
        static let mediaCell = "mediaCell"
        static let sectionHeader = "SectionHeader"
        static let sectionFooter = "SectionFooter"
        
        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 3.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    @IBAction func homeButtonTap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //store.createDummyDimeMedia()
        let bgImage = UIImageView()
        bgImage.image = #imageLiteral(resourceName: "background_GREY")
        bgImage.contentMode = .scaleToFill
        
        
        self.collectionView?.backgroundView = bgImage
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if imagesToEdit.count == 9 {
            return 9
        }else{
        
        return imagesToEdit.count + 1
    }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.mediaCell, for: indexPath) as! MediaCollectionViewCell

        
        cell.layer.cornerRadius = 3.0
        cell.layer.masksToBounds = true
        cell.mediaImageView.image = #imageLiteral(resourceName: "PLUS")
        if imagesToEdit.count - 1 >= indexPath.row{
        cell.mediaImageView.image = imagesToEdit[indexPath.row]
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeaderCollectionReusableView
            
             headerView.sectionTitleLabel.text = store.currentUser?.username
             headerView.profileImage.image = #imageLiteral(resourceName: "icon-profile")
             return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionFooter", for: indexPath) as! SectionFooterCollectionReusableView
            
           // footerView.diamondImage.image = #imageLiteral(resourceName: "icon-diamond-black")
        //footerView.likesCountButton.titleLabel?.text = "7"
            return footerView
            
        default:
            
            assert(false, "Unexpected element kind")
        }
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            
                if self.imagesToEdit.count >= indexPath.row + 1 { self.imagesToEdit.remove(at: indexPath.row) }
                self.imagesToEdit.insert(image!, at: indexPath.row)
                collectionView.reloadData()
            
            
        })
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "showMedia") {
//            let viewController = segue.destination as! MediaTableViewController
//            viewController.passedIndex = selectedIndexPath
//            
//        }
//    }
}























