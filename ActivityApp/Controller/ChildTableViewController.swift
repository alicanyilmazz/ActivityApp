//
//  ChildTableViewController.swift
//  ActivityApp
//
//  Created by alican on 7.03.2022.
//

import UIKit

class ChildTableViewController: UITableViewController {

    var selectedActivity : Activity?{
        didSet{
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
}
