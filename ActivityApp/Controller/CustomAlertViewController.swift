//
//  CustomAlertViewController.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import UIKit

protocol CustomViewControllerDelegate{
    func okButtonTapped(data : String)
    func cancelButtonTapped()
}

class CustomAlertViewController: UIViewController {

    @IBOutlet weak var MessageLbl: UILabel!
    @IBOutlet weak var firstTextFieldLeftIcon: UIImageView!
    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var firstTextFieldWarningLbl: UILabel!
    @IBOutlet weak var firstTextFieldWarningImage: UIImageView!
    @IBOutlet weak var acceptBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var firstTextFieldBaseView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    var delegate : CustomViewControllerDelegate? = nil
    var validationComponentBuilder : ValidationComponentBuilderProtocol = ValidationComponentBuilder()
    var activitiesTextField : UITextFieldComponent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setComponents()
        setComponentsUIFeatures()
    }
}

extension CustomAlertViewController{
    
    fileprivate func setComponentsUIFeatures() {
        firstTextField.delegate = self
        firstTextField.borderStyle = .none
        
        firstTextFieldBaseView.layer.cornerRadius = 15
        firstTextFieldBaseView.clipsToBounds = false
        firstTextFieldBaseView.layer.shadowOpacity = 0.3
        firstTextFieldBaseView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        
        mainView.layer.cornerRadius = 15
        mainView.clipsToBounds = false
        mainView.layer.shadowOpacity = 0.3
        mainView.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        
        acceptBtn.layer.cornerRadius = 15
        cancelBtn.layer.cornerRadius = 15
    }
    
    fileprivate func setComponents() {
        activitiesTextField = UITextFieldComponent(componentType: ComponentType.activitySection.activityName, validations: validationComponentBuilder.content[SectionName.activity].components[ComponentType.activitySection.activityName].validations)
        if let text = firstTextField.text{
            activitiesTextField.value = text
        }
    }
    
    fileprivate func setUIValidation(_ result: (error: Bool, message: String)) {
        if result.error == false{
            firstTextFieldWarningLbl.text = result.message
            firstTextFieldWarningLbl.textColor = .systemPink
            firstTextFieldWarningImage.image = UIImage(named: "cancel")
        }else{
            firstTextFieldWarningLbl.text = "Everthing seems good."
            firstTextFieldWarningLbl.textColor = .systemGreen
            firstTextFieldWarningImage.image = UIImage(named: "accept")
        }
    }
    
    fileprivate func isEmpty(_ text: String) {
        if text.isEmpty{
            firstTextFieldWarningLbl.text = "opps you can enter a value."
            firstTextFieldWarningLbl.textColor = .systemPink
            firstTextFieldWarningImage.image = UIImage(named: "cancel")
        }
    }
}

extension CustomAlertViewController : UITextFieldDelegate{
    @IBAction func firstTextFieldEditing(_ sender: UITextField) {
        guard let text = firstTextField.text else { return }
        validationComponentBuilder.update(val: text, sectionName: SectionName.activity, componentType: ComponentType.activitySection.activityName)
        let result = validationComponentBuilder.isValid(sectionName: SectionName.activity, componentType: ComponentType.activitySection.activityName)
        setUIValidation(result)
    }
    
}

extension CustomAlertViewController{
    @IBAction func addBtnClicked(_ sender: UIButton) {
        guard let text = firstTextField.text?.trimmingLeadingAndTrailingSpaces() else { return }
        isEmpty(text)
        let result = validationComponentBuilder.isEverythingValid(sectionName: SectionName.activity)
        if result{
            delegate?.okButtonTapped(data: text.capitalizingFirstLetter())
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

