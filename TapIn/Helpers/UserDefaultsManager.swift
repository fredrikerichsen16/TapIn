import Foundation

class UserDefaultsManager {
    static var standard = UserDefaultsManager()
    
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
            defaults.bool(forKey: AppStorageKey.subscribed)
        }
        set {
            defaults.set(newValue, forKey: AppStorageKey.subscribed)
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
    
    // folderIsExpanded
    
    func getFolderIsExpanded(folderId id: String) -> Bool {
        let key = "folderIsExpanded-\(id)"
        
        return defaults.bool(forKey: key)
    }
    
    func setFolderIsExpanded(folderId id: String, value: Bool) {
        let key = "folderIsExpanded-\(id)"
        
        defaults.set(value, forKey: key)
    }
    
    // last radio channel
    
    var radioChannelIndex: Int {
        get {
            defaults.integer(forKey: AppStorageKey.radioChannelIndex)
        } set {
            defaults.set(newValue, forKey: AppStorageKey.radioChannelIndex)
        }
    }
    
    // cascading
    
    var cascadingOptions: Set<WorkspaceTab> {
        get {
            guard let stringRepresentation = defaults.stringArray(forKey: AppStorageKey.cascadingOptions) else {
                return Set()
            }
            
            let enumRepresentation = stringRepresentation.compactMap({ WorkspaceTab(rawValue: $0) })
            
            return Set(enumRepresentation)
        }
        set {
            let arrayRepresentation = Array(newValue)
            let stringArrayRepresentation = arrayRepresentation.map({ $0.rawValue })
            
            defaults.set(stringArrayRepresentation, forKey: AppStorageKey.cascadingOptions)
        }
    }
    
    // enableNotifications
    
    var notificationsEnabled: Bool {
        get {
            defaults.bool(forKey: AppStorageKey.notificationsEnabled)
        }
        set {
            defaults.set(newValue, forKey: AppStorageKey.notificationsEnabled)
        }
    }
    
}
