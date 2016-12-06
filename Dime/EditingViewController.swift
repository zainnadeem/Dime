//
//  EditingViewController.swift
//  Dime
//
//  Created by Zain Nadeem on 11/30/16.
//  Copyright © 2016 Zain Nadeem. All rights reserved.
//

import UIKit
import GooglePlacePicker


class EditingViewController: UIViewController {
    
    var mediaCollectionViewController = MediaCollectionViewController()
    let store = DataStore.sharedInstance
    var passedDime: Dime!
    var dime: Dime?
    
    @IBOutlet weak var dimeNumberLabel: UILabel!
    @IBOutlet weak var dimeImage: UIImageView!
    @IBOutlet weak var captionButton: UIButton!
    @IBOutlet weak var tagPeopleButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    @IBOutlet weak var captionTextField: UITextField!
   
    var currentImageNumber = Int()
    var numberOfImagesToEdit = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     captionTextField.isHidden = true
     captionTextField.delegate = self
     dime = passedDime
     currentImageNumber = 1
     backButton.isEnabled = false
     numberOfImagesToEdit = (dime?.media.count)!
     dimeNumberLabel.text = "\(currentImageNumber)/\(numberOfImagesToEdit)"
     dimeImage.image = dime?.media[currentImageNumber-1].mediaImage

    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        mediaCollectionViewController.passedDime = dime
        dismiss(animated: true, completion: nil)
    }

    @IBAction func locationButtonTapped(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    @IBAction func tagPeopleTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowTaggingController", sender: nil)
    }
    
    @IBAction func captionButtonTapped(_ sender: Any) {
        captionTextField.isHidden = false
        captionTextField.text = dime?.media[currentImageNumber - 1].caption
        captionTextField.becomeFirstResponder()
        forwardButton.isEnabled = false
        backButton.isEnabled = false
        
        
    }
    
    @IBAction func forwardButtonTapped(_ sender: Any) {
        if currentImageNumber >= 1 && currentImageNumber < numberOfImagesToEdit {
        currentImageNumber = currentImageNumber + 1
        dimeImage.image = dime?.media[currentImageNumber-1].mediaImage
            dimeNumberLabel.text = "\(currentImageNumber)/\(numberOfImagesToEdit)"
        }
        enableButtons()
    }

    @IBAction func backButtonTapped(_ sender: Any) {
        if currentImageNumber > 1 && currentImageNumber <= numberOfImagesToEdit {
        currentImageNumber = currentImageNumber - 1
        dimeImage.image = dime?.media[currentImageNumber-1].mediaImage
        dimeNumberLabel.text = "\(currentImageNumber)/\(numberOfImagesToEdit)"
    }
        enableButtons()
    }
    

    func enableButtons() {
        
        if currentImageNumber == numberOfImagesToEdit {
            forwardButton.isEnabled = false
        }else {
            forwardButton.isEnabled = true
        }
        
        if currentImageNumber == 1 {
            backButton.isEnabled = false
        }else{
            backButton.isEnabled = true
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowTaggingController"{
            let destinationVC = segue.destination as! UINavigationController
            let targetController = destinationVC.topViewController as! TaggingViewController
            targetController.editViewController = self
            targetController.passedMedia = dime?.media[currentImageNumber - 1]
        }
    }
}

extension EditingViewController: UITextFieldDelegate {
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dime?.media[currentImageNumber - 1].caption = captionTextField.text!
        captionTextField.isHidden = true
        self.enableButtons()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        self.view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
 
}

extension EditingViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        self.dime?.media[self.currentImageNumber - 1].location = place.name
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
