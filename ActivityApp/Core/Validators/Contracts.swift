//
//  Contracts.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

protocol ValidationComponentBuilderProtocol{
    var content : [UISectionComponent] {get}
    func isValid(sectionName : Int ,componentType : Int) -> (error : Bool , message : String)
    func isEverythingValid(sectionName : Int) -> Bool
    func update(val: Any , sectionName : Int , componentType : Int)
}

protocol UIComponentProtocol{
    var id: UUID {get}
    var componentType: Int {get}
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

