import Foundation

class UserDefaultsManager {
    static var main = UserDefaultsManager()
    
    let defaults = UserDefaults.standard
    
    private init() {}
    
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
}
