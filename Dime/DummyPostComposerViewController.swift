//
//  DummyPostComposerViewController.swift
//  Moments
//
//  Created by Zain Nadeem on 11/9/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit

class DummyPostComposerViewController: UIViewController {

    var imagePickerHelper: ImagePickerHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    

  
    }
    

    
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addImageDidTap(_ sender: Any) {
        
        
        
            imagePickerHelper = ImagePickerHelper(viewController: self, completion: { (image) in
            
            let postComposerNVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Storyboard.postComposerNVC) as! UINavigationController
            let postComposerVC = postComposerNVC.topViewController as! PostComposerViewController
            
            postComposerVC.image = image
            self.present(postComposerNVC, animated: true, completion: nil)
            
            
        })
   
    
    
    }
}
