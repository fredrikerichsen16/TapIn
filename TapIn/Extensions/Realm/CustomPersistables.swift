import Foundation
import RealmSwift

extension URL: FailableCustomPersistable {
    public typealias PersistedType = String
    
    public init?(persistedValue: String) {
        self.init(string: persistedValue)
    }
    
    public var persistableValue: String {
        self.absoluteString
    }
}
