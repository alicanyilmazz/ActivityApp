//
//  Enums.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

enum SectionName : Int{
    case activity = 0
    case signin = 1
    case signup = 2
}

enum CustomValidationError : Error{
    case custom(message : String)
}

enum RegexValidationPatterns{
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{3,64}"
    static let between3to20 = "^.{3,20}$"
    static let alphabetic = "^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$"
    static let between3to15 = "^.{3,15}$"
}

enum ComponentType: Int{
    case activityName = 0
    case name = 1
    case surname = 2
    case email = 3
}

struct RegexModel{
    let pattern : String
    let error : CustomValidationError
}

