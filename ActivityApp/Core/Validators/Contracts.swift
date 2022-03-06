//
//  Contracts.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

protocol ValidationComponentBuilderProtocol{
    var content : [UISectionComponent] {get}
    func isValid(sectionName : SectionName ,componentType : ComponentType) -> (error : Bool , message : String)
    func isEverythingValid(sectionName : SectionName) -> Bool
    func update(val: Any , sectionName : SectionName , componentType : ComponentType)
}

protocol UIComponentProtocol{
    var id: UUID {get}
    var componentType: ComponentType {get}
    var validations: [ValidatorManager] {get}
}

protocol UISectionComponentProtocol{
    var id : UUID {get}
    var components: [UIComponent] {get}
    init(components: [UIComponent])
}

protocol ValidatorManager{
    func validate(_ val:Any) throws
}

