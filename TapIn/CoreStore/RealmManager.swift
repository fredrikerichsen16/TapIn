//
//  RealmManager.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 27/01/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    public static let shared = RealmManager()
    
    private(set) var realm: Realm
    
    init() {
        do {
            let config = Realm.Configuration(schemaVersion: 2)
            
            self.realm = try Realm(configuration: config)
        }
        catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
}
