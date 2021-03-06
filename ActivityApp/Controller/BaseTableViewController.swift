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
        //performSegue(withIdentifier: "goDetail", sender: self)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! BaseTableViewCell  //UITableViewCell(style: .default, reuseIdentifier: "Cell") as! BaseTableViewCell
        //cell.textLabel?.text = activities?[indexPath.row].name ?? "activity not found."
        
        let sumOfPayments : Int = activities?[indexPath.row].peyments.sum(ofProperty: "balance") ?? 0
        
        if let name = activities?[indexPath.row].name{
            //cell.textLabel?.text = "\(name) - \(sumOfPayments)"
            cell.setAttributes(activityName: name, price: "\(sumOfPayments)")
        }else{
            cell.setAttributes(activityName: "No Activity", price: "0")
        }
        
        if activities?[indexPath.row].isCompleted == false{
            cell.setUIFeatures(status: true)
        }else{
            cell.setUIFeatures(status: false)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
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
    */
    
    /*
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "") { action, indexpath in
            if let deletedActivity = self.activities?[indexPath.row]{
                do {
                    try self.realm.write({
                        self.realm.delete(deletedActivity.peyments)
                        self.realm.delete(deletedActivity)
                    })
                } catch {
                    print("Could not deleted : \(error.localizedDescription)")
                }
            }
            tableView.reloadData()
        }
        
        delete.backgroundColor = .systemPink
        
        let balance = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "") { action, indexpath in
            if let activite = self.activities?[indexPath.row] {
                do {
                    try self.realm.write({
                        activite.isCompleted = true
                    })
                } catch {
                    print("opps balance error : \(error.localizedDescription)")
                }
            }
        }
        
        balance.backgroundColor = .yellow
        
        return [delete,balance]
    }
    */
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            if let deletedActivity = self.activities?[indexPath.row]{
                do {
                    try self.realm.write({
                        self.realm.delete(deletedActivity.peyments)
                        self.realm.delete(deletedActivity)
                    })
                } catch {
                    print("Could not deleted : \(error.localizedDescription)")
                }
            }
            completionHandler(true)
            tableView.reloadData()
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = .systemPink
        
        let balanceAction = UIContextualAction(style: .destructive, title: nil) { _, _, completionHandler in
            if let activite = self.activities?[indexPath.row] {
                do {
                    try self.realm.write({
                        if activite.isCompleted == false{
                            activite.isCompleted = true
                        }else{
                            activite.isCompleted = false
                        }
                    })
                } catch {
                    print("opps balance error : \(error.localizedDescription)")
                }
            }
            completionHandler(true)
            tableView.reloadData()
            let frame = CGRect(x: 0, y: 0, width: (self.view.frame.size.width)/1.2, height: 60)
            var message = ""
            if let activite = self.activities?[indexPath.row]{
                if activite.isCompleted == false{
                    message = "Payments in this account have been cleared."
                }else{
                    message = "There are unpaid monies."
                }
            }
            let viewModel = SnackbarViewModel(type: .info, text: message, image: UIImage(systemName: "bell"))
            let snackbar = SnackbarView(viewModel: viewModel, frame: frame)
            self.showSnacbar(snackBar: snackbar)
        }
        
        balanceAction.image = UIImage(systemName: "pencil")
        balanceAction.backgroundColor = .lightGray
        
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction,balanceAction])
        return configuration
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
    
    public func showSnacbar(snackBar : SnackbarView){
        let width = view.frame.size.width/1.2
        snackBar.frame = CGRect(x: (view.frame.size.width-width)/2, y: self.view.frame.size.height, width: width, height: 60)
        view.addSubview(snackBar)
        UIView.animate(withDuration: 0.5 , animations: {
            snackBar.frame = CGRect(x: (self.view.frame.size.width - width)/2, y: (self.view.frame.size.height) - 190, width: width, height: 60)
        },completion: { done in
            if done{
                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                    UIView.animate(withDuration: 0.3 , animations: {
                        snackBar.frame = CGRect(x: (self.view.frame.size.width-width)/2, y: self.view.frame.size.height, width: width, height: 60)
                    },completion: { finished in
                        if finished{
                            snackBar.removeFromSuperview()
                        }
                    })
                })
            }
        })
    }
}


