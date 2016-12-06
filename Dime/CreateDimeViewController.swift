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
        
        imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            
            self.store.currentDime = Dime(caption: "", createdBy: self.store.currentUser!, media: [])
            let newMedia = Media(type: "", caption: "", createdBy: self.store.currentUser!, image: image!, location: "")
            self.store.currentDime?.media.append(newMedia)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "MediaCollectionViewController") as! MediaCollectionViewController
            
           // controller.exercisedPassed = "Ex1"
            
            self.present(controller, animated: true, completion: nil)
            
            
            // self.performSegue(withIdentifier: "mediaCollectionSegue", sender: nil)
            
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
        print("Not sure what the left bar button will do yet.")
    }
    
    func middleBarButtonTapped(_ Sender: AnyObject) {
        print("Not sure what the middle bar button will do yet.")
    }
    
}
