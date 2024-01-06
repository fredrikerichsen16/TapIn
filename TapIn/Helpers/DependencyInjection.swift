//
//  DependencyInjection+.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 30/01/2023.
//

import Foundation
import Factory
import RealmSwift

extension Container {
    static let userDefaults = Factory<UserDefaultsManager>(scope: .singleton) { UserDefaultsManager.standard }
    static let urlSession = Factory<URLSession>(scope: .singleton) { URLSession.shared }
    static let realm = Factory<Realm>(scope: .singleton) { RealmManager().realm }
    
    /// Register dependencies used in unit tests and previews
    static func setupMocks() {
        realm.register { RealmManagerMock().realm }
    }
}
