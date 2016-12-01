//
//  CreateDimeViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/29/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class CreateDimeViewController: UIViewController {
    
    let store = DataStore.sharedInstance
    var imagePickerHelper: ImagePickerHelper!
    var passedImage: UIImage = UIImage()
    

    @IBOutlet weak var dimeTitleTextField: UITextField!
    
    @IBOutlet weak var dimeCoverPhoto: UIButton!
    
    @IBOutlet weak var numberOfImages: UILabel!
    
    @IBOutlet weak var timeLeftToPostLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func centerCameraTapped(_ sender: Any) {
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            
            self.store.currentDime = Dime(caption: "", createdBy: self.store.currentUser!, media: [])
            let newMedia = Media(type: "", caption: "", createdBy: self.store.currentUser!, image: image!, location: "")
            self.store.currentDime?.media.append(newMedia)
            
            self.performSegue(withIdentifier: "mediaCollectionSegue", sender: nil)
            
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
