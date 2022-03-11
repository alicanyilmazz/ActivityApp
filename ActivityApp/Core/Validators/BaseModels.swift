//
//  BaseModels.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

class UIComponent : UIComponentProtocol,Hashable{
    let id: UUID = UUID()
    let componentType: Int
    var value: Any?
    var validations: [ValidatorManager]
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: UIComponent, rhs: UIComponent) -> Bool{
            lhs.id == rhs.id
    }
    
    init(componentType : Int , validations: [ValidatorManager] = []){
        self.componentType = componentType
        self.validations = validations
    }
}

class UISectionComponent : UISectionComponentProtocol,Hashable{
    let id: UUID = UUID()
    var components: [UIComponent]
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: UISectionComponent, rhs: UISectionComponent) -> Bool{
            lhs.id == rhs.id
        }
    
    required init(components: [UIComponent] = []){
        self.components = components
    }
}

