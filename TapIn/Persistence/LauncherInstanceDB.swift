import Foundation
import RealmSwift

final class LauncherInstanceDB: EmbeddedObject {
    @Persisted
    var id = ObjectId.generate()
    
    @Persisted
    var name: String
    
    @Persisted
    var appUrl: URL?
    
    @Persisted
    var fileUrl: URL?
    
    @Persisted
    var launchDelay: TimeInterval = 0.0
    
    @Persisted
    var hideOnLaunch: Bool = false
    
    @Persisted
    var active: Bool = true

    @Persisted
    var type: RealmLauncherType
    
    @Persisted
    var instantiated: Bool = false
    
    @Persisted(originProperty: "launcherInstances")
    var launcher: LinkingObjects<LauncherDB>
    
    // MARK: Initialize
    
    convenience init(name: String, type: RealmLauncherType, instantiated: Bool, appUrl: URL? = nil, fileUrl: URL? = nil, launchDelay: TimeInterval = 0.0, hideOnLaunch: Bool = false) {
        self.init()
        self.name = name
        self.type = type
        self.instantiated = instantiated
        self.appUrl = appUrl
        self.fileUrl = fileUrl
        self.launchDelay = launchDelay
        self.hideOnLaunch = hideOnLaunch
    }
    
    convenience init(duplicate instance: LauncherInstanceDB) {
        self.init()
        self.name = instance.name
        self.type = instance.type
        self.instantiated = instance.instantiated
        self.appUrl = instance.appUrl
        self.fileUrl = instance.fileUrl
        self.launchDelay = instance.launchDelay
        self.hideOnLaunch = instance.hideOnLaunch
    }
    
    convenience init(empty type: RealmLauncherType, hideOnLaunch: Bool = false) {
        self.init()
        self.name = "New \(type.label)"
        self.type = type
        self.instantiated = false
        self.hideOnLaunch = hideOnLaunch
        
        if type == .terminal, let terminalApp = URL(string: "/Applications/Utilities/Terminal.app/") {
            self.appUrl = terminalApp
        }
    }
}

enum RealmLauncherType: String, Equatable, PersistableEnum {
    case app
    case file
    case folder
    case website
    case terminal
    
    var label: String {
        switch self {
        case .app:
            return "App"
        case .file:
            return "File"
        case .folder:
            return "Folder"
        case .website:
            return "Website"
        case .terminal:
            return "Terminal"
        }
    }
    
    var icon: String {
        switch self
        {
        case .app:
            return "music.note"
        case .file:
            return "doc"
        case .folder:
            return "folder"
        case .website:
            return "link"
        case .terminal:
            return "terminal"
        }
    }
}
