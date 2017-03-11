//
//  AddTopDimesViewController.swift
//  Dime
//
//  Created by Lloyd W. Sykes on 3/11/17.
//  Copyright © 2017 Zain Nadeem. All rights reserved.
//

import UIKit

class AddTopDimeViewController: UIViewController {
    
}

extension AddTopDimeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath)
        return cell
    }
}
