//
//  SubChildViewController.swift
//  ActivityApp
//
//  Created by alican on 9.03.2022.
//

import UIKit
import RealmSwift

class SubChildViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstTextFieldRightImage: UIImageView!
    @IBOutlet weak var firstTextFieldWarningLbl: UILabel!
    
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var secondTextFieldRightImage: UIImageView!
    @IBOutlet weak var secondTextFieldWarningLbl: UILabel!
    
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var thirdTextFieldRightImage: UIImageView!
    @IBOutlet weak var thirdTextFieldWarningLbl: UILabel!
    
    @IBOutlet weak var firstBaseView: UIView!
    @IBOutlet weak var secondBaseView: UIView!
    @IBOutlet weak var thirdBaseView: UIView!
    @IBOutlet weak var fourthBaseView: UIView!
    
    @IBOutlet weak var fourthLblActivityName: UILabel!
    @IBOutlet weak var fourthLblTotalPayment: UILabel!
    
    @IBOutlet weak var saveBtn: UIButton!
    
    var selectedPayment : Payment?
    var selectedActivite : Activity?
    let realm = try! Realm()
    
    var payersTextField : UITextFieldComponent!
    var explanationTextField : UITextFieldComponent!
    var costTextField : UITextFieldComponent!
    
    var validationComponentBuilder : ValidationComponentBuilderProtocol = ValidationComponentBuilder()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUI()
        setComponents()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setComponentsUIFeatures()
        
    }
    
    func setUI(){
        firstTextField.text = selectedPayment?.payersName
        secondTextField.text = selectedPayment?.explanation
        thirdTextField.text = "\(selectedPayment!.balance)"
        fourthLblActivityName.text = "\(selectedActivite!.name)"
        let totalPayments = selectedActivite?.peyments.filter("payersName == %@", selectedPayment!.payersName).sum(ofProperty: "balance") ?? 0
        fourthLblTotalPayment.text = "\(totalPayments)"
    }
}

extension SubChildViewController{
    fileprivate func setComponentsUIFeatures() {
        firstTextField.delegate = self
        firstTextField.borderStyle = .none
        
        secondTextField.delegate = self
        secondTextField.borderStyle = .none
        
        thirdTextField.delegate = self
        thirdTextField.borderStyle = .none
        
        firstBaseView.layer.cornerRadius = 15
        firstBaseView.clipsToBounds = false
        firstBaseView.layer.shadowOpacity = 0.3
        firstBaseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        secondBaseView.layer.cornerRadius = 15
        secondBaseView.clipsToBounds = false
        secondBaseView.layer.shadowOpacity = 0.3
        secondBaseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        thirdBaseView.layer.cornerRadius = 15
        thirdBaseView.clipsToBounds = false
        thirdBaseView.layer.shadowOpacity = 0.3
        thirdBaseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        fourthBaseView.layer.cornerRadius = 15
        fourthBaseView.clipsToBounds = false
        fourthBaseView.layer.shadowOpacity = 0.7
        fourthBaseView.layer.shadowColor = UIColor.red.cgColor
        fourthBaseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        saveBtn.layer.cornerRadius = 15
    }
    
    fileprivate func setComponents() {
        payersTextField = UITextFieldComponent(componentType: ComponentType.editSection.payerName, validations: validationComponentBuilder.content[SectionName.edit].components[ComponentType.editSection.payerName].validations)
        if let text = firstTextField.text{
            validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.payerName)
            payersTextField.value = text
        }

        explanationTextField = UITextFieldComponent(componentType: ComponentType.editSection.explanation, validations: validationComponentBuilder.content[SectionName.edit].components[ComponentType.editSection.explanation].validations)
        if let text = secondTextField.text{
            validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.explanation)
            explanationTextField.value = text
        }
        
        costTextField = UITextFieldComponent(componentType: ComponentType.editSection.cost, validations: validationComponentBuilder.content[SectionName.edit].components[ComponentType.editSection.cost].validations)
        if let text = thirdTextField.text{
            validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.cost)
            costTextField.value = text
        }
    }
}

extension SubChildViewController : UITextFieldDelegate{
    @IBAction func firstTextFieldChanged(_ sender: UITextField) {
        guard let text = firstTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.payerName)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.edit, componentType: ComponentType.editSection.payerName)
        setUIValidation(result,warningLbl: firstTextFieldWarningLbl,warningImage: firstTextFieldRightImage)
    }
    
    @IBAction func secondTextFieldChanged(_ sender: Any) {
        guard let text = secondTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.explanation)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.edit, componentType: ComponentType.editSection.explanation)
        setUIValidation(result,warningLbl: secondTextFieldWarningLbl,warningImage: secondTextFieldRightImage)
    }
    
    @IBAction func thirdTextFieldChanged(_ sender: UITextField) {
        guard let text = thirdTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.edit, componentType: ComponentType.editSection.cost)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.edit, componentType: ComponentType.editSection.cost)
        setUIValidation(result,warningLbl: thirdTextFieldWarningLbl,warningImage: thirdTextFieldRightImage)
    }
   
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        guard let firstText = firstTextField.text?.trimmingLeadingAndTrailingSpaces() else { return }
        isEmpty(firstText,warningLbl: firstTextFieldWarningLbl,warningImage: firstTextFieldRightImage)
        guard let seconText = secondTextField.text?.trimmingLeadingAndTrailingSpaces() else { return }
        isEmpty(seconText,warningLbl: secondTextFieldWarningLbl,warningImage: secondTextFieldRightImage)
        guard let thirdText = thirdTextField.text?.trimmingLeadingAndTrailingSpaces() else { return }
        isEmpty(thirdText , warningLbl: thirdTextFieldWarningLbl,warningImage: thirdTextFieldRightImage)
        let result = validationComponentBuilder.isEverythingValid(sectionName: SectionName.edit)
        if result{
            if let selectedPayment = selectedPayment{
                do {
                    try realm.write({
                        selectedPayment.payersName = firstText.capitalizingFirstLetter()
                        selectedPayment.explanation = seconText.capitalizingFirstLetter()
                        selectedPayment.balance = Int(thirdText)!
                    })
                } catch {
                    print("Data not updated \(error.localizedDescription)")
                }
            }
            navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func setUIValidation(_ result: (error: Bool, message: String) , warningLbl : UILabel , warningImage : UIImageView) {
        if result.error == false{
            warningLbl.text = result.message
            warningLbl.textColor = .systemPink
            warningImage.image = UIImage(named: "cancel")
        }else{
            warningLbl.text = "Everthing seems good."
            warningLbl.textColor = .systemGreen
            warningImage.image = UIImage(named: "accept")
        }
    }
    
    fileprivate func isEmpty(_ text: String , warningLbl : UILabel , warningImage : UIImageView) {
        if text.isEmpty{
            warningLbl.text = "opps you can enter a value."
            warningLbl.textColor = .systemPink
            warningImage.image = UIImage(named: "cancel")
        }
    }

}
