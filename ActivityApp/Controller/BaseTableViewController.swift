//
//  BaseTableViewController.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import UIKit
import RealmSwift

class BaseTableViewController: UITableViewController{

    @IBOutlet weak var searchBar: UISearchBar!
    
    var activities : Results<Activity>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        
        let sumOfPayments : Int = activities?[indexPath.row].peyments.sum(ofProperty: "balance") ?? 0
        
        if let name = activities?[indexPath.row].name{
            cell.textLabel?.text = "\(name) - \(sumOfPayments)"
        }else{
            cell.textLabel?.text = "Activity not found."
        }
        
        if activities?[indexPath.row].isCompleted ?? false{
            cell.accessoryType = .checkmark
        }else{
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let deletedActivity = activities?[indexPath.row]{
                do {
                    try realm.write({
                        realm.delete(deletedActivity.peyments)
                        realm.delete(deletedActivity)
                    })
                } catch {
                    print("Could not deleted : \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
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

extension BaseTableViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        loadData()
        //activities = activities?.filter("name CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "name", ascending: true)
        activities = activities?.where{
            $0.name.contains(text, options: .caseInsensitive)
        }.sorted(byKeyPath: "name", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.count == 0 {
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

