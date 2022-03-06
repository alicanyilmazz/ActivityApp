//
//  BaseTableViewController.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import UIKit

class BaseTableViewController: UITableViewController{

    override func viewDidLoad() {
        super.viewDidLoad()

     
    }

    
    @IBAction func addActivityBtnClicked(_ sender: UIBarButtonItem) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomAlertViewController") as! CustomAlertViewController
        customAlert.delegate = self
        customAlert.modalPresentationStyle = .overCurrentContext
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalTransitionStyle = .crossDissolve
        self.present(customAlert, animated: true, completion: nil)
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

extension BaseTableViewController :  CustomViewControllerDelegate{
    func okButtonTapped(data: String) {
        
    }
    
    func cancelButtonTapped() {
        
    }
    
    
}
