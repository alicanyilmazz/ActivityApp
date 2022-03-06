//
//  Managers.swift
//  ActivityApp
//
//  Created by alican on 6.03.2022.
//

import Foundation

struct RegexValidatorManager : ValidatorManager{
    
    private let regexModels: [RegexModel]
    
    init(_ regexModels: [RegexModel]){
        self.regexModels = regexModels
    }
    
    func validate(_ val: Any) throws {
        let val = (val as? String) ?? ""
        
        try regexModels.forEach({ eachOfRegex in
            let regex = try? NSRegularExpression(pattern: eachOfRegex.pattern, options: .allowCommentsAndWhitespace)
            let range = NSRange(location: 0, length: val.count)
            if regex?.firstMatch(in: val, options: [], range: range) == nil{
                throw eachOfRegex.error
            }
        })
        
    }
}

struct DateValidationManager : ValidatorManager{

    private let ageLimit: Int = 18
    
    func validate(_ val: Any) throws {
        guard let date = val as? Date else { throw CustomValidationError.custom(message: "Invalid Value Passed") }
        
        if let calculatedYr = Calendar.current.dateComponents([.year], from: date,to: Date()).year , calculatedYr < ageLimit{
            throw CustomValidationError.custom(message: "User is below the age of 18")
        }
    }
}
