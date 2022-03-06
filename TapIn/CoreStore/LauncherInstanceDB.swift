import Foundation
import RealmSwift

final class LauncherInstanceDB: Object, ObjectKeyIdentifiable {
    
    // MARK: Persisted properties
    
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
    
    var fullType: LauncherType {
        type.convertToLauncherType(instantiated: instantiated)
    }
    
    @Persisted(originProperty: "launcherInstances")
    var launcher: LinkingObjects<LauncherDB>
    
    // MARK: Initialize
    
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
    
    // MARK: Set up bridge
    
    lazy var appController: AppController = {
        switch fullType {
            case .app:
                return AppLauncherAppController(parent: self)
            case .file:
                return FileLauncherAppController(parent: self)
            case .folder:
                return FileLauncherAppController(parent: self)
            case .website:
                return WebsiteLauncherAppController(parent: self)
            case .terminal:
                fatalError("3131232144")
            case .empty(_):
                return EmptyLauncherAppController(parent: self)
        }
    }()

    lazy var fileController: FileController = {
        switch fullType {
            case .app:
                return AppLauncherFileController(parent: self)
            case .file:
                return FileLauncherFileController(parent: self)
            case .folder:
                return FileLauncherFileController(parent: self)
            case .website:
                return WebsiteLauncherFileController(parent: self)
            case .terminal:
                fatalError("4234324")
            case .empty(_):
                return EmptyLauncherFileController(parent: self)
        }
    }()

    lazy var opener: Opener = {
        switch fullType {
            case .app:
                return AppLauncherOpener(parent: self)
            case .file:
                return FileLauncherOpener(parent: self)
            case .folder:
                return FileLauncherOpener(parent: self)
            case .website:
                return WebsiteLauncherOpener(parent: self)
            case .terminal:
                fatalError("4234324")
            case .empty(_):
                return EmptyLauncherOpener(parent: self)
        }
    }()

    lazy var panel: Panel = {
        switch type {
            case .app:
                return AppLauncherPanel(parent: self)
            case .file:
                return FileLauncherPanel(parent: self)
            case .folder:
                return FolderLauncherPanel(parent: self)
            case .website:
                return WebsiteLauncherPanel(parent: self)
            case .terminal:
                fatalError("31037490")
        }
    }()
    
    // MARK: CRUD
    
    
}

enum RealmLauncherType: String, Equatable, PersistableEnum {
    case app
    case file
    case folder
    case website
    case terminal
    
    func label() -> String {
        switch self {
            case .app:
                return "New App"
            case .file:
                return "New File"
            case .folder:
                return "New Folder"
            case .website:
                return "New Website"
            case .terminal:
                return "New Terminal"
        }
    }
    
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
