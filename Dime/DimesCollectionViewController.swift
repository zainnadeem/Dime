////
////  DimesCollectionViewController.swift
////  Dime
////
////  Created by Zain Nadeem on 11/21/16.
////  Copyright © 2016 Zain Nadeem. All rights reserved.
////
////
//
//import UIKit
//
//class DimesCollectionViewController: UICollectionViewController
//{
//    var store = DataStore.sharedInstance
//    
//    struct Storyboard {
//        static let publisherCell = "PublisherCell"
//        static let sectionHeader = "SectionHeader"
//        
//        static let leftAndRightPaddings: CGFloat = 32.0 // 3 items per row, meaning 4 paddings of 8 each
//        static let numberOfItemsPerRow: CGFloat = 3.0
//        static let titleHeightAdjustment: CGFloat = 30.0
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        let collectionViewWidth = collectionView?.frame.width
//        let itemWidth = (collectionViewWidth! - Storyboard.leftAndRightPaddings) / Storyboard.numberOfItemsPerRow
//        
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth + Storyboard.titleHeightAdjustment)
//    }
//    
//    // MARK: - UICollectionViewDataSource
//    
//    override func numberOfSections(in collectionView: UICollectionView) -> Int
//    {
//        return store.currentUser?.dimes.count
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    {
//        
//        if store.currentUser?.dimes[IndexPath.row].media.count < 9 {
//            return store.currentUser?.dimes[IndexPath.row].media.count + 1
//        } else {
//                return 9
//        }
//        
//        //store.numberOfPublishers(inSection: section)
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
//    {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.publisherCell, for: indexPath) as! DimeCollectionViewCell
//        let dime = store.currentUser?.dimes[indexPath.row]
//        
//        cell.media = dime.media[indexPath.row]
//        
//        return cell
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
//    {
//        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Storyboard.sectionHeader, for: indexPath) as! SectionHeaderCollectionReusableView
//        
//        if let publisher = store.publisherForItem(atIndexPath: indexPath) {
//            headerView.publisher = publisher
//        }
//        
//        return headerView
//    }
//}
//
