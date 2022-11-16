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
    
    var cascadingOptions: Set<WorkspaceTab> {
        get {
            guard let stringRepresentation = defaults.stringArray(forKey: "cascadingOptions") else {
                return Set()
            }
            
            let enumRepresentation = stringRepresentation.compactMap({ WorkspaceTab(rawValue: $0) })
            
            return Set(enumRepresentation)
        }
        set {
            let arrayRepresentation = Array(newValue)
            let stringArrayRepresentation = arrayRepresentation.map({ $0.rawValue })
            
            defaults.set(stringArrayRepresentation, forKey: "cascadingOptions")
        }
    }
    
}
