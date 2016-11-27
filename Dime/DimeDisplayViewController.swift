////
////  DimeDisplayViewController.swift
////  
////
////  Created by Zain Nadeem on 11/5/16.
////
////
//
//import UIKit
//
//class DimeDisplayViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    
//     let store = DataStore()
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        store.createDummyDimeMedia()
//
//        let itemWidth = self.view.frame.width
//        let itemHeight = self.view.frame.height
//        
//        let layout = collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//
//     override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }
//    
//    
//     override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//   
//
//        return (store.currentDime?.media.count)!
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DimeImageDisplayCollectionViewCell
//        
//        cell.setCellProperties(withDimeMedia: (store.currentDime?.media[indexPath.row])!)
//        
//        return cell
//    }
//
//
//}
//
//
//    
//    
//    
//
