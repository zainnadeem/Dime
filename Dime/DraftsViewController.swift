//
//  DraftsViewController.swift
//  Dime
//
//  Created by Lloyd W. Sykes on 2/22/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class DraftsViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var draftsTableView: UITableView!
    
    let store = DataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewCustomizations()
        
    }
    
    func viewCustomizations() {
        tableViewSetup()
        navigationController?.navigationBar.barTintColor = .sideMenuGrey()
        editButton.tintColor = .white
        doneButton.tintColor = .white
        
    }
    
    func tableViewSetup() {
        draftsTableView.delegate = self
        draftsTableView.dataSource = self
        draftsTableView.estimatedRowHeight = 150
        draftsTableView.reloadData()
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        if !draftsTableView.isEditing {
            draftsTableView.isEditing = true
        } else {
            draftsTableView.isEditing = false
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension DraftsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let draftCount = store.currentUser?.drafts?.count else {
            print("There was an error unwrapping the count of drafts in the DraftViewController")
            return 1
        }
        return draftCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "draftsCell") as! DraftsTableViewCell
        
        
        if let drafts = store.currentUser?.drafts {
            for draft in drafts {
                
                
                //                draft.downloadCoverImage(coverPhoto: "", completion: { (image, error) in
                //
                //                    cell.draftImageView.image = image
                //
                //                })
                for media in draft.media {
                    cell.draftImageView.image = media.mediaImage
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
