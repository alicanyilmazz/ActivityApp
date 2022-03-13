//
//  Builders.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

final class ValidationComponentBuilder : ValidationComponentBuilderProtocol {

   private(set) var content = [
    UISectionComponent(components: [
        UITextFieldComponent(componentType: ComponentType.activitySection.activityName,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to25, error: .custom(message: "you can enter between 3 to 25."))
           ])])
        ]),
    UISectionComponent(components: [
        UITextFieldComponent(componentType: ComponentType.paymentSection.payerName,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to25, error: .custom(message: "you can enter between 3 to 25."))
           ])]),
        UITextFieldComponent(componentType: ComponentType.paymentSection.explanation,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to25, error: .custom(message: "you can enter between 3 to 25."))
           ])]),
        UITextFieldComponent(componentType: ComponentType.paymentSection.cost,validations: [
           RegexValidatorManager([
            RegexModel(pattern: RegexValidationPatterns.onlyNumber, error: .custom(message: "you must be only enter numbers.")),
            RegexModel(pattern: RegexValidationPatterns.between1to6, error: .custom(message: "you can enter between 1 to 6."))
           ])])
        ]),
    UISectionComponent(components: [
        UITextFieldComponent(componentType: ComponentType.editSection.payerName,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to25, error: .custom(message: "you can enter between 3 to 25."))
           ])]),
        UITextFieldComponent(componentType: ComponentType.editSection.explanation,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to25, error: .custom(message: "you can enter between 3 to 25."))
           ])]),
        UITextFieldComponent(componentType: ComponentType.editSection.cost,validations: [
           RegexValidatorManager([
            RegexModel(pattern: RegexValidationPatterns.onlyNumber, error: .custom(message: "you must be only enter numbers.")),
            RegexModel(pattern: RegexValidationPatterns.between1to6, error: .custom(message: "you can enter between 1 to 6."))
           ])])
        ])
     ]
   
    func update(val: Any ,sectionName : Int ,componentType : Int){
        content[sectionName].components[componentType].value = val
   }
    
    func isValid(sectionName : Int ,componentType : Int) -> (error : Bool , message : String){
       do {
           let component = content[sectionName].components[componentType]
           for validator in component.validations{
               try validator.validate(component.value as Any)
           }
           return (true, "")
       } catch  {
           if let validationError = error as? CustomValidationError{
               switch validationError {
               case .custom(let message):
                   return (false,message)
               }
           }
           return (false , "unknown error")
       }
   }
   
    func isEverythingValid(sectionName : Int) -> Bool{
       do {
           let components = content[sectionName].components
           for component in components {
               for validator in component.validations{
                   try validator.validate(component.value as Any)
               }
           }
           return true
       } catch  {
           return false
       }
   }
}

