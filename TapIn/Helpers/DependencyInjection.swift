import Foundation
import Factory
import RealmSwift

extension Container {
    
//    var userDefaults = Factory<UserDefaultsManager> {
//        self { UserDefaultsManager.standard }
//            .singleton
//    }
    
//    var urlSession = Factory<URLSession> {
//        self { URLSession.shared }
//            .singleton
//    }
    
    var realmManager: Factory<RealmManager> {
        Factory(self) { RealmManager() }
            .singleton
    }
    
//    var singletonService: Factory<SimpleService> {
//            self { SimpleService() }
//                .singleton
//        }
    
//    static let userDefaults = Factory<UserDefaultsManager> {
//        Factory(self, scope: .singleton) {
//            UserDefaultsManager.standard
//        }
//    }
    
    /// Register dependencies used in unit tests and previews
//    static func setupMocks() {
//        realm.register { RealmManagerMock() }
//    }
}
