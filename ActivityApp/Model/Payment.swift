//
//  Payment.swift
//  ActivityApp
//
//  Created by alican on 7.03.2022.
//

import Foundation
import RealmSwift

class Payment : Object{
    @Persisted var id : ObjectId
    @Persisted var payersName : String = ""
    @Persisted var explanation : String = ""
    @Persisted var balance : Int = -1
    @Persisted(originProperty: "peyments") var assignee: LinkingObjects<Activity>
}
