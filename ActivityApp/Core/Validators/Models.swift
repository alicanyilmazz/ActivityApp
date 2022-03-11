//
//  Models.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

final class UITextFieldComponent : UIComponent{
    override init(componentType: Int, validations: [ValidatorManager] = []) {
        super.init(componentType: componentType, validations: validations)
    }
}

final class UIDateComponent : UIComponent{
    override init(componentType: Int, validations: [ValidatorManager] = []) {
        super.init(componentType: componentType, validations: validations)
    }
}

