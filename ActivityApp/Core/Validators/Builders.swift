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
       UITextFieldComponent(componentType: .activityName,validations: [
           RegexValidatorManager([
               RegexModel(pattern: RegexValidationPatterns.alphabetic, error: .custom(message: "you must be only enter string.")),
               RegexModel(pattern: RegexValidationPatterns.between3to15, error: .custom(message: "you can enter between 3 to 25."))
           ])])
        ])
     ]
   
    func update(val: Any ,sectionName : SectionName ,componentType : ComponentType){
        content[sectionName.rawValue].components[componentType.rawValue].value = val
   }
    
    func isValid(sectionName : SectionName ,componentType : ComponentType) -> (error : Bool , message : String){
       do {
           let component = content[sectionName.rawValue].components[componentType.rawValue]
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
   
    func isEverythingValid(sectionName : SectionName) -> Bool{
       do {
           let components = content[sectionName.rawValue].components
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

