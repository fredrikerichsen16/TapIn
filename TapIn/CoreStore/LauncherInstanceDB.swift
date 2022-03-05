import Foundation
import RealmSwift

final class LauncherInstanceDB: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true)
    var id: ObjectId
    
    @Persisted
    var name: String
    
    @Persisted
    var appPath: String?
    
    var appUrl: URL? {
        if let path = appPath {
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    @Persisted
    var filePath: String?
    
    var fileUrl: URL? {
        if let path = filePath {
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    @Persisted
    var launchDelay: TimeInterval = 0.0
    
    @Persisted
    var hideOnLaunch: Bool = false
    
    @Persisted
    var type: RealmLauncherType
    
    @Persisted
    var instantiated: Bool = false
    
    @Persisted(originProperty: "launcherInstances")
    var launcher: LinkingObjects<LauncherDB>
    
    lazy var launcherBridge: LaunchInstanceBridge? = {
        let launcherType = type.convertToLauncherType(instantiated: self.instantiated)
//        let launcherType = LauncherType.empty(LauncherType.app)
        
        let result = LaunchInstanceBridge.createLauncherFromType(type: launcherType, name: name, app: appUrl, file: fileUrl)
//        let result = LaunchInstanceBridge.createAppLauncher(name: name, app: URL(fileURLWithPath: "/Applications/Craft.app"), file: nil)
        
        if let thawed = self.thaw(),
           let thawedRealm = thawed.realm {
            try! thawedRealm.write {
                thawed.instantiated = true
            }
        }
        
        return result
    }()
    
    convenience init(name: String, type: RealmLauncherType, instantiated: Bool, appPath: String? = nil, filePath: String? = nil, launchDelay: TimeInterval = 0.0, hideOnLaunch: Bool = false) {
        self.init()
        self.name = name
        self.type = type
        self.instantiated = instantiated
        self.appPath = appPath
        self.filePath = filePath
        self.launchDelay = launchDelay
        self.hideOnLaunch = hideOnLaunch
    }
    
    convenience init(name: String, type: RealmLauncherType, instantiated: Bool) {
        self.init()
        self.name = name
        self.type = type
        self.instantiated = instantiated
    }
}

enum RealmLauncherType: String, Equatable, PersistableEnum {
    case app
    case file
    case folder
    case website
    case terminal
    
    func convertToLauncherType(instantiated: Bool) -> LauncherType {
        var primaryType: LauncherType
        
        switch self {
            case .app:
                primaryType = LauncherType.app
            case .file:
                primaryType = LauncherType.file
            case .folder:
                primaryType = LauncherType.folder
            case .terminal:
                primaryType = LauncherType.terminal
            case .website:
                primaryType = LauncherType.website
        }
        
        if !instantiated {
            return LauncherType.empty(primaryType)
        }
        
        return primaryType
    }
}
