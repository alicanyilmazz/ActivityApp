//
//  BaseTableViewController.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import UIKit
import RealmSwift

class BaseTableViewController: UITableViewController{

    var activities : Results<Activity>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return activities?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetail"{
            let targetVC = segue.destination as! ChildTableViewController
            
            if let selectedIndex = tableView.indexPathForSelectedRow{
                targetVC.selectedActivity = activities?[selectedIndex.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = activities?[indexPath.row].name ?? "activity not found."
        
        if activities?[indexPath.row].isCompleted ?? false{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
}

extension BaseTableViewController :  CustomViewControllerDelegate{
    func okButtonTapped(data : String) {
        let activite = Activity()
        activite.name = data
        activite.isCompleted = false
        saveData(activity: activite)
        tableView.reloadData()
    }
    
    func cancelButtonTapped() {
        
    }
}

extension BaseTableViewController{
    func saveData(activity : Activity) {
        do {
            try realm.write{
                realm.add(activity)
            }
        } catch {
            print("Data could not added to database error message : \(error)")
        }
    }
    
    func loadData() {
            activities = realm.objects(Activity.self)
            tableView.reloadData()
    }
}
