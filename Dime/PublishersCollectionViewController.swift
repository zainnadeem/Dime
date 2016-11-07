//
//
//  Created by Zain Nadeem on 11/05/16.
//

import UIKit

class PublishersCollectionViewController: UICollectionViewController
{
    var store = DataStore.sharedInstance
    var selectedIndexPath: Int = Int()
    
    
    struct Storyboard {
        static let publisherCell = "PublisherCell"
        static let sectionHeader = "SectionHeader"
        
        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
        static let numberOfItemsPerRow: CGFloat = 3.0
        static let titleHeightAdjustment: CGFloat = 30.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.createDummyDimeMedia()
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
        return (store.currentDime?.media.count)!
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.publisherCell, for: indexPath) as! PublisherCollectionViewCell
        let dimeMedia = store.currentDime?.media[indexPath.row]
        
        cell.dimeMedia = dimeMedia
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.sectionHeader, for: indexPath) as! SectionHeaderCollectionReusableView
        
       headerView.sectionTitleLabel.text = "Jonny Appleseed"
        
        return headerView
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath.row
        performSegue(withIdentifier: "showMedia", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showMedia") {
            let viewController = segue.destination as! MediaTableViewController
            viewController.passedIndex = selectedIndexPath
            
        }
    }
}























