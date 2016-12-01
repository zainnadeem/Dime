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
    var passedDime: Dime!
    var dime: Dime?
    

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
        dime = passedDime
        let bgImage = UIImageView()
        bgImage.image = #imageLiteral(resourceName: "background_GREY")
        bgImage.contentMode = .scaleToFill
        self.collectionView?.backgroundView = bgImage
        let collectionViewWidth = collectionView?.frame.width
        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
        
        
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
//        if (dime?.media.count)! > 3 {
            self.performSegue(withIdentifier: "showEditView", sender: nil)
//        } else {
//            alert(title: "Oops!", message: "Please select at least four items to edit", buttonTitle: "Got it!")
//        }
//        
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
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            
            let newMedia = Media(type: "", caption: "", createdBy: self.store.currentUser!, image: image!, location: "")
            
            if (self.dime?.media.count)! >= indexPath.row + 1 { self.dime?.media.remove(at: indexPath.row) }
            self.dime?.media.insert(newMedia, at: indexPath.row)
            collectionView.reloadData()
            
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEditView" {
            store.currentDime = dime
            let destinationVC = segue.destination as! UINavigationController
            let targetController = destinationVC.topViewController as! EditingViewController
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




















