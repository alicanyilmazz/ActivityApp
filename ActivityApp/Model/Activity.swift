//
//  Activity.swift
//  ActivityApp
//
//  Created by alican on 7.03.2022.
//

import Foundation
import RealmSwift

class Activity : Object{
    @Persisted var id : ObjectId
    @Persisted var name : String = ""
    @Persisted var isCompleted : Bool = false
    @Persisted var peyments : List<Payment>
}
