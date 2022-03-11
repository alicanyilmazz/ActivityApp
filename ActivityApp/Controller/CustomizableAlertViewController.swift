//
//  CustomizableAlertViewController.swift
//  ActivityApp
//
//  Created by alican on 8.03.2022.
//

import UIKit

protocol CustomizableViewControllerDelegate{
    func okButtonTapped(payersName : String , explanation : String , cost : String)
    func cancelButtonTapped()
}

class CustomizableAlertViewController: UIViewController {

    @IBOutlet weak var messageLbl: UILabel!
    
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstTextFieldLeftIcon: UIImageView!
    @IBOutlet weak var firstTextFieldWarningLbl: UILabel!
    @IBOutlet weak var firstTextFieldWarningIcon: UIImageView!
    
    @IBOutlet weak var seconTextField: UITextField!
    @IBOutlet weak var seconTextFieldLeftIcon: UIImageView!
    @IBOutlet weak var seconTextFieldWarningLbl: UILabel!
    @IBOutlet weak var seconTextFieldWarningIcon: UIImageView!
    
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var thirdTextFieldLeftIcon: UIImageView!
    @IBOutlet weak var thirdTextFieldWarningLbl: UILabel!
    @IBOutlet weak var thirdTextFieldWarningIcon: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var baseView: UIView!
    
    
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var delegate : CustomizableViewControllerDelegate? = nil
    var validationComponentBuilder : ValidationComponentBuilderProtocol = ValidationComponentBuilder()
    var activitiesTextField : UITextFieldComponent!
    
    var payersTextField : UITextFieldComponent!
    var explanationTextField : UITextFieldComponent!
    var costTextField : UITextFieldComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setComponents()
        setComponentsUIFeatures()
        // Do any additional setup after loading the view.
    }
}

extension CustomizableAlertViewController : UITextFieldDelegate{
    @IBAction func firstTextFieldChanged(_ sender: UITextField) {
        guard let text = firstTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.payment, componentType: ComponentType.paymentSection.payerName)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.payment, componentType: ComponentType.paymentSection.payerName)
        setUIValidation(result,warningLbl: firstTextFieldWarningLbl,warningImage: firstTextFieldWarningIcon)
    }
    
    @IBAction func seconTextFieldChanged(_ sender: UITextField) {
        guard let text = seconTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.payment, componentType: ComponentType.paymentSection.explanation)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.payment, componentType: ComponentType.paymentSection.explanation)
        setUIValidation(result,warningLbl: seconTextFieldWarningLbl,warningImage: seconTextFieldWarningIcon)
    }
    
    @IBAction func thirdTextFieldChanged(_ sender: UITextField) {
        guard let text = thirdTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.payment, componentType: ComponentType.paymentSection.cost)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.payment, componentType: ComponentType.paymentSection.cost)
        setUIValidation(result,warningLbl: thirdTextFieldWarningLbl,warningImage: thirdTextFieldWarningIcon)
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        guard let firstText = firstTextField.text else { return }
        isEmpty(firstText,warningLbl: firstTextFieldWarningLbl,warningImage: firstTextFieldWarningIcon)
        guard let seconText = seconTextField.text else { return }
        isEmpty(seconText,warningLbl: seconTextFieldWarningLbl,warningImage: seconTextFieldWarningIcon)
        guard let thirdText = thirdTextField.text else { return }
        isEmpty(thirdText , warningLbl: thirdTextFieldWarningLbl,warningImage: thirdTextFieldWarningIcon)
        let result = validationComponentBuilder.isEverythingValid(sectionName: SectionName.payment)
        if result{
            delegate?.okButtonTapped(payersName: firstText, explanation: seconText, cost: thirdText)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension CustomizableAlertViewController{
    
    fileprivate func setComponentsUIFeatures() {
        firstTextField.delegate = self
        firstTextField.borderStyle = .none
        
        seconTextField.delegate = self
        seconTextField.borderStyle = .none
        
        thirdTextField.delegate = self
        thirdTextField.borderStyle = .none
        
        baseView.layer.cornerRadius = 15
        baseView.clipsToBounds = false
        baseView.layer.shadowOpacity = 0.3
        baseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        
        mainView.layer.cornerRadius = 15
        mainView.clipsToBounds = false
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        addBtn.layer.cornerRadius = 15
        cancelBtn.layer.cornerRadius = 15
    }
    
    fileprivate func setComponents() {
        payersTextField = UITextFieldComponent(componentType: ComponentType.paymentSection.payerName, validations: validationComponentBuilder.content[SectionName.payment].components[ComponentType.paymentSection.payerName].validations)
        if let text = firstTextField.text{
            payersTextField.value = text
        }

        explanationTextField = UITextFieldComponent(componentType: ComponentType.paymentSection.explanation, validations: validationComponentBuilder.content[SectionName.payment].components[ComponentType.paymentSection.explanation].validations)
        if let text = seconTextField.text{
            explanationTextField.value = text
        }
        
        costTextField = UITextFieldComponent(componentType: ComponentType.paymentSection.cost, validations: validationComponentBuilder.content[SectionName.payment].components[ComponentType.paymentSection.cost].validations)
        if let text = thirdTextField.text{
            costTextField.value = text
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
