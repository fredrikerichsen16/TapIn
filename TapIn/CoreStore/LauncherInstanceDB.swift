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
    
    var fullType: LauncherType {
        type.convertToLauncherType(instantiated: instantiated)
    }
    
    @Persisted(originProperty: "launcherInstances")
    var launcher: LinkingObjects<LauncherDB>
    
//    lazy var launcherBridge: LaunchInstanceBridge? = {
//        let launcherType = type.convertToLauncherType(instantiated: self.instantiated)
////        let launcherType = LauncherType.empty(LauncherType.app)
//
//        let result = LaunchInstanceBridge.createLauncherFromType(type: launcherType, name: name, app: appUrl, file: fileUrl)
////        let result = LaunchInstanceBridge.createAppLauncher(name: name, app: URL(fileURLWithPath: "/Applications/Craft.app"), file: nil)
//
//        if let thawed = self.thaw(),
//           let thawedRealm = thawed.realm {
//            try! thawedRealm.write {
//                thawed.instantiated = true
//            }
//        }
//
//        return result
//    }()
    
    convenience init(name: String, type: RealmLauncherType, instantiated: Bool, appPath: String? = nil, filePath: String? = nil, launchDelay: TimeInterval = 0.0, hideOnLaunch: Bool = false) {
        self.init()
        self.name = name
        self.type = type
        self.instantiated = instantiated
        self.appPath = appPath
        self.filePath = filePath
        self.launchDelay = launchDelay
        self.hideOnLaunch = hideOnLaunch
        
//        self.initializeBridge()
    }
    
    convenience init(name: String, type: RealmLauncherType, instantiated: Bool) {
        self.init()
        self.name = name
        self.type = type
        self.instantiated = instantiated
        
//        self.initializeBridge()
    }
    
    // ...
    
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
    
//    var fileController: FileController!
//    var appController: AppController!
//    var opener: Opener!
//    var panel: Panel!
//
//    func initializeBridge() {
//        if !instantiated {
//            initializeEmptyLauncher(type: type)
//
//            return
//        }
//
//        switch type {
//            case .app:
//                initializeAppLauncher()
//            case .file:
//                initializeFileLauncher()
//            case .folder:
//                initializeFolderLauncher()
//            case .website:
//                initializeWebsiteLauncher()
//            default:
//                fatalError("32489234")
//        }
//    }
//
//    func initializeEmptyLauncher(type: RealmLauncherType) {
//        var typeConformingPanel: Panel
//
//        switch type {
//            case .app:
//                typeConformingPanel = AppLauncherPanel(parent: self)
//            case .file:
//                typeConformingPanel = FileLauncherPanel(parent: self)
//            case .folder:
//                typeConformingPanel = FolderLauncherPanel(parent: self)
//            case .website:
//                typeConformingPanel = WebsiteLauncherPanel(parent: self)
//            default:
//                if !instantiated
//                {
//                    typeConformingPanel = EmptyLauncherPanel(parent: self)
//                }
//                else {
//                    fatalError("Not yet fully supported type")
//                }
//        }
//
//        self.appController = EmptyLauncherAppController(parent: self, app: nil)
//        self.fileController = EmptyLauncherFileController(parent: self, file: nil)
//        self.opener = EmptyLauncherOpener(parent: self)
//        self.panel = typeConformingPanel
//    }
//
//    func initializeAppLauncher() {
//        guard let app = appUrl else { return }
//        let file = fileUrl
//
//        self.appController = AppLauncherAppController(parent: self, app: app)
//        self.fileController = AppLauncherFileController(parent: self, file: file)
//        self.opener = AppLauncherOpener(parent: self)
//        self.panel = AppLauncherPanel(parent: self)
//    }
//
//    func initializeFileLauncher() {
//        guard let file = fileUrl else { return }
//        let app = appUrl
//
//        self.appController = FileLauncherAppController(parent: self, app: app)
//        self.fileController = FileLauncherFileController(parent: self, file: file)
//        self.opener = FileLauncherOpener(parent: self)
//        self.panel = FileLauncherPanel(parent: self)
//    }
//
//    func initializeFolderLauncher() {
//        guard let file = fileUrl else { return }
//        let app = appUrl
//
//        self.appController = FileLauncherAppController(parent: self, app: app)
//        self.fileController = FileLauncherFileController(parent: self, file: file)
//        self.opener = FileLauncherOpener(parent: self)
//        self.panel = FolderLauncherPanel(parent: self)
//    }
//
//    func initializeWebsiteLauncher() {
//        guard let file = fileUrl else { return }
//        let app = appUrl
//
//        self.appController = WebsiteLauncherAppController(parent: self, app: app)
//        self.fileController = WebsiteLauncherFileController(parent: self, file: file)
//        self.opener = WebsiteLauncherOpener(parent: self)
//        self.panel = WebsiteLauncherPanel(parent: self)
//    }
//
//    func convertFromEmpty(type emptyType: LauncherType) {
//        var type = emptyType
//
//        if case let .empty(innerType) = emptyType {
//            type = innerType
//
//            instantiated = true
//        } else {
//            return
//        }
//
//        switch type {
//            case .app:
//                initializeAppLauncher()
//            case .file:
//                initializeFileLauncher()
//            case .folder:
//                initializeFolderLauncher()
//            case .website:
//                initializeWebsiteLauncher()
//            default:
//                return
//        }
//    }
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
