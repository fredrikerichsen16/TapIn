import Cocoa
import RealmSwift

// ------------------------
// HELPER FUNCTIONS
// ------------------------

func getAppIcon(for app: URL, size: Int) -> NSImage {
    let image = NSWorkspace.shared.icon(forFile: app.path)
        image.size = NSSize(width: size, height: size)
    
    return image
}

func getAbsentAppIcon(size: Int) -> NSImage {
    let image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil)!
        image.size = NSSize(width: size, height: size)
    
    return image
}

func getDefaultApp(fileUrl: URL) -> URL? {
    return NSWorkspace.shared.urlForApplication(toOpen: fileUrl)
}

func applicationReadableName(url: URL) -> String {
   return FileManager.default.displayName(atPath: url.path)
}

func convertURL(urlString: String) -> URL? {
    var str = urlString.lowercased().trim()

    if !(str.starts(with: "https://") || str.starts(with: "http://")) {
        str = "https://" + str
    }

    let regex = "^(https?:\\/\\/)?([\\da-z\\.-]+\\.[a-z\\.]{2,6}|[\\d\\.]+)([\\/:?=&#]{1}[\\da-z\\.-]+)*[\\/\\?]?$"
    // adding [c] after the comparator (MATCHES) makes it case insensitive
    let predicate = NSPredicate(format:"SELF MATCHES[c] %@", argumentArray:[regex])

    if predicate.evaluate(with: str) == false {
        return nil
    }

    return URL(string: str)
}

// MAIN PART

protocol BaseLauncherInstanceBehavior: Identifiable {
    var id: ObjectId { get }
    var name: String { get }
    var type: RealmLauncherType { get }
    var object: LauncherInstanceDB { get }
    
    func getIcon(size: Int) -> NSImage
    func update(app: URL?, file: URL?)
    
    func write(_ block: (() -> Void))
}

extension BaseLauncherInstanceBehavior {
    var id: ObjectId {
        return object.id
    }
    
    var name: String {
        return object.name
    }
    
    var instantiated: Bool {
        return object.instantiated
    }
    
    func getIcon(size: Int) -> NSImage {
        return getAbsentAppIcon(size: size)
    }
    
    func update(app: URL?, file: URL?) {
        let realm = RealmManager.shared.realm
        guard let object = object.thaw() else { return }
        
        try? realm.write {
            if let app {
                let name = applicationReadableName(url: app)
                
                object.appUrl = app
                object.name = name
            }
            
            if let file {
                let name = applicationReadableName(url: file)
                
                object.fileUrl = file
                object.name = name
            }
            
            object.instantiated = true
        }
    }
    
    func write(_ block: (() -> Void)) {
        let realm = RealmManager.shared.realm
        try? realm.write {
            block()
        }
    }
}

protocol FileSystemBasedBehavior {
    func createPanel() -> NSOpenPanel
    
    /// Open a panel for selecting a file, app or directory and return the selected file and whether the operation was completed (as opposed to cancelled by the user)
    /// - Parameter panel: NSPanel
    /// - Returns: 1) Selected file/directory's URL 2) Boolean indicating whether the file selection operation was completed
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool)
    
    func submittedFileWithPanel(url: URL)
}

//protocol UninstantiatedLauncher {
//    func submittedFileWithPanel(url: URL)
//}

protocol WebBasedBehavior {
    func setName(name: String)
    func setUrl(urlString: String)
}

protocol Openable {
    func open()
}

protocol FileBehavior {
    var file: URL { get }
    var app: URL? { get }
    
    func getCompatibleApps() -> [URL]
}

protocol AppBehavior {
    var app: URL { get }
}


func launcherInstanceFactory(instance: LauncherInstanceDB) -> (any BaseLauncherInstanceBehavior)? {
    switch (instance.type, instance.instantiated)
    {
    case (.app, true):
        return InstantiatedAppLauncher(instance: instance)
    case (.app, false):
        return UninstantiatedAppLauncher(instance: instance)
    case (.file, true):
        return InstantiatedFileLauncher(instance: instance)
    case (.file, false):
        return UninstantiatedFileLauncher(instance: instance)
    case (.folder, true):
        return InstantiatedFolderLauncher(instance: instance)
    case (.folder, false):
        return UninstantiatedFolderLauncher(instance: instance)
    case (.website, true):
        return InstantiatedWebLauncher(instance: instance)
    case (.website, false):
        return UninstantiatedWebLauncher(instance: instance)
//    case (.terminal, true):
//        return InstantiatedFolderLauncher(instance: instance)
//    case (.terminal, false):
//        return UninstantiatedFolderLauncher(instance: instance)
    default:
        return nil
    }
}
