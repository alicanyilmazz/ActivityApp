//
//  Enums.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation


enum CustomValidationError : Error{
    case custom(message : String)
}

enum RegexValidationPatterns{
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,64}"
    static let between3to20 = "^.{3,20}$"
    static let alphabetic = "[a-zA-Z]"
    static let between3to15 = "^.{3,15}$"
    static let onlyNumber = "^[0-9]+$"
    static let onlyDecimalNumber = "^-?[0-9][0-9,\\.]+$"
    static let between1to6 = "^.{1,6}$"
}

enum SectionName{
    static let activity = 0
    static let payment = 1
    static let edit = 2
}

enum ComponentType {
    
    enum activitySection{
        static let activityName = 0
    }
    
    enum paymentSection{
        static let payerName = 0
        static let explanation = 1
        static let cost = 2
    }
    
    enum editSection{
        static let payerName = 0
        static let explanation = 1
        static let cost = 2
    }
    
}

struct RegexModel{
    let pattern : String
    let error : CustomValidationError
}

