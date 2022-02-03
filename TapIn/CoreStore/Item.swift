//
//  Item.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import Foundation
import RealmSwift

final class Item: Object, ObjectKeyIdentifiable {

    @objc dynamic var _id = ObjectId.generate()
    
    @objc dynamic var name: String = Item.randomName()
    
    @objc dynamic var isFavorite: Bool = false
    
    override class func primaryKey() -> String? {
        return "_id"
    }
    
    static func randomName() -> String {
        let randomNames = ["floor", "monitor", "puddle", "brush", "bread", "glass", "ring", "coaster"]
        
        return randomNames.randomElement() ?? "new item"
    }
    
    // Inverse
    var group = LinkingObjects(fromType: Group.self, property: "items")
    
}
