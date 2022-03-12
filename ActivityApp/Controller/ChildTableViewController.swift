//
//  ChildTableViewController.swift
//  ActivityApp
//
//  Created by alican on 7.03.2022.
//

import UIKit
import RealmSwift

class ChildTableViewController: UITableViewController, CustomizableViewControllerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    var payments : Results<Payment>?
    let realm = try! Realm()
    var selectedActivity : Activity?{
        didSet{
            loadPayments()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    @IBAction func addBtnClicked(_ sender: UIBarButtonItem) {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "CustomizableAlertViewController") as! CustomizableAlertViewController
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
        return payments?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "paymentEditSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "paymentEditSegue"{
            let targetVC = segue.destination as! SubChildViewController
            if let selectedIndex = tableView.indexPathForSelectedRow{
                if let selectedPayment = payments?[selectedIndex.row]{
                    targetVC.selectedPayment = selectedPayment
                    targetVC.selectedActivite = selectedActivity
                    targetVC.title = "\(selectedPayment.payersName)"
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ChildTableViewCell
        if let payment = payments?[indexPath.row] {
            //cell.textLabel?.text = "\(payment.payersName) - \(payment.balance) $"
            cell.setAttributes(activityName: payment.payersName, price: "\(payment.balance)")
        }else{
            cell.setAttributes(activityName: "No any payment", price: "0")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let selectedPayment = payments?[indexPath.row]{
                do {
                    try realm.write({
                        realm.delete(selectedPayment)
                    })
                } catch {
                    print("Could not deleted : \(error.localizedDescription)")
                }
            }
        }
        tableView.reloadData()
    }
    
    func loadPayments(){
        payments = selectedActivity?.peyments.sorted(byKeyPath: "payersName", ascending: true)
    }
    
    func okButtonTapped(payersName: String, explanation: String, cost: String) {
        let payment = Payment()
        payment.payersName = payersName
        payment.explanation = explanation
        payment.balance = Int(cost) ?? 0
        saveData(payment: payment)
    }
    
    func cancelButtonTapped() {
        
    }
}

extension ChildTableViewController{
    func saveData(payment : Payment) {
        do {
            try realm.write{
                selectedActivity?.peyments.append(payment)
                tableView.reloadData()
                //realm.add(payment)
            }
        } catch {
            print("Data could not added to database error message : \(error)")
        }
    }
    
    func loadData() {
            payments = realm.objects(Payment.self)
            tableView.reloadData()
    }
}

extension ChildTableViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        loadData()
        //payments = payments?.filter("payersName == %@", text).sorted(byKeyPath: "balance", ascending: true)
        payments = payments?.where{
            $0.payersName.contains(text, options: .caseInsensitive)
        }.sorted(byKeyPath: "balance", ascending: true)
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
