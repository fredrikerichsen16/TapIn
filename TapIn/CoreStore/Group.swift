//
//  Group.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import Foundation
import RealmSwift

final class Group: Object, ObjectKeyIdentifiable {
    
    @objc dynamic var _id = ObjectId.generate()
    
    @objc dynamic var name: String = "new"
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    var items = RealmSwift.List<Item>()
    
}
