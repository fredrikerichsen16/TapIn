import Foundation

class UserDefaultsManager {
    static var main = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
    private init() {}
    
    func clear() {
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
    // subscribed
    
    var subscribed: Bool {
        get {
            defaults.bool(forKey: "subscribed")
        }
        set {
            defaults.set(newValue, forKey: "subscribed")
        }
    }
    
    // last tab
    
    func getLatestTab(for workspace: WorkspaceDB) -> WorkspaceTab? {
        let key = "latestTab-\(workspace.id.stringValue)"
        
        if let lastTabRawValue = defaults.string(forKey: key) {
            return WorkspaceTab(rawValue: lastTabRawValue)
        }
        
        return nil
    }
    
    func setLatestTab(for workspace: WorkspaceDB, tab: WorkspaceTab) {
        let key = "latestTab-\(workspace.id.stringValue)"
        
        Task {
            defaults.set(tab.rawValue, forKey: key)
        }
    }
    
    // last radio channel
    
    var radioChannelIndex: Int {
        get {
            defaults.integer(forKey: "radioChannelIndex")
        } set {
            defaults.set(newValue, forKey: "radioChannelIndex")
        }
    }
    
    // cascading
    
//    var cascadingStart: Set<WorkspaceTab> {
//        get {
//            return defaults.object(forKey: "cascadingStart") as? Set<WorkspaceTab> ?? Set([])
//        }
//        set {
//            defaults.set(newValue, forKey: "cascadingStart")
//        }
//    }
//
//    var cascadingPause: Set<WorkspaceTab> {
//        get {
//            return defaults.object(forKey: "cascadingPause") as? Set<WorkspaceTab> ?? Set([])
//        }
//        set {
//            defaults.set(newValue, forKey: "cascadingPause")
//        }
//    }
    
    private func getCascading(key: String) -> Set<WorkspaceTab> {
        guard let stringRepresentation = defaults.stringArray(forKey: key) else {
            return Set()
        }
        
        let enumRepresentation = stringRepresentation.compactMap({ WorkspaceTab(rawValue: $0) })
        
        return Set(enumRepresentation)
    }
    
    private func setCascading(key: String, value: Set<WorkspaceTab>) {
        let arrayRepresentation = Array(value)
        let stringArrayRepresentation = arrayRepresentation.map({ $0.rawValue })
        
        defaults.set(stringArrayRepresentation, forKey: key)
    }
    
    var cascadingStart: Set<WorkspaceTab> {
        get {
            return getCascading(key: "cascadingStart")
        }
        set {
            setCascading(key: "cascadingStart", value: newValue)
        }
    }
    
    var cascadingPause: Set<WorkspaceTab> {
        get {
            return getCascading(key: "cascadingPause")
        }
        set {
            setCascading(key: "cascadingPause", value: newValue)
        }
    }
    
    var cascadingStop: Set<WorkspaceTab> {
        get {
            return getCascading(key: "cascadingStop")
        }
        set {
            setCascading(key: "cascadingStop", value: newValue)
        }
    }
    
}
