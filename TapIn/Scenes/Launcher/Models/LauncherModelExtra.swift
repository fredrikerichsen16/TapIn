import Cocoa
import RealmSwift

// ------------------------
// GENERAL PURPOSE
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

// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

protocol DisplayableBehavior {
    var name: String { get }
    var type: RealmLauncherType { get }
    func getIcon(size: Int) -> NSImage
}

extension DisplayableBehavior {
    var name: String {
        return "New \(type.label)"
    }
    
    func getIcon(size: Int) -> NSImage {
        return getAbsentAppIcon(size: size)
    }
}

protocol BaseLauncherInstanceBehavior: DisplayableBehavior, Identifiable {
    var id: UUID { get }
    var object: LauncherInstanceDB { get set }
    
    func update(app: URL?, file: URL?)
}

//extension Instantiated {}

extension BaseLauncherInstanceBehavior {
    func update(app: URL?, file: URL?) {
        let realm = RealmManager.shared.realm
        guard let object = object.thaw() else { return }
        
        try? realm.write {
            if let app = app {
                object.appUrl = app
            }
            
            if let file = file {
                object.fileUrl = file
            }
        }
    }
}

protocol FileSystemBasedBehavior {
    func createPanel() -> NSOpenPanel
    
    /// Open a panel for selecting a file, app or directory and return the selected file and whether the operation was completed (as opposed to cancelled by the user)
    /// - Parameter panel: NSPanel
    /// - Returns: 1) Selected file/directory's URL 2) Boolean indicating whether the file selection operation was completed
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool)
}

extension FileSystemBasedBehavior {
    
}

protocol WebBasedBehavior {
    func checkurl(url: URL) -> Bool
}

protocol Openable {
    func open()
}

protocol FileBehavior {
    var file: URL { get }
    var app: URL? { get }
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
    default:
        return nil
    }
}







// ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

// LauncherInstanceModel
//
//protocol LauncherInstanceModel {
//    var appController: AppController! { get set }
//    var fileController: FileController! { get set }
//    var opener: Opener! { get set }
//    
//    var object: LauncherInstanceDB { get set }
//    var app: URL? { get set }
//    var file: URL? { get set }
//    var instantiated: Bool { get set }
//    
//    func update(app: URL?, file: URL?, instantiated: Bool?)
//}
//
//extension LauncherInstanceModel {
//    var app: URL? {
//        object.appUrl
//    }
//    
//    var file: URL? {
//        object.fileUrl
//    }
//    
//    var instantiated: Bool {
//        object.instantiated
//    }
//    
//    func update(app: URL?, file: URL?, instantiated: Bool?) {
//        let realm = RealmManager.shared.realm
//        guard let object = object.thaw() else { return }
//        
//        try? realm.write {
//            if let app = app {
//                object.appUrl = app
//            }
//            
//            if let file = file {
//                object.fileUrl = file
//            }
//            
//            if let instantiated = instantiated {
//                object.instantiated = instantiated
//            }
//        }
//    }
//}
//
//protocol FileSystemLauncherInstanceProtocol: LauncherInstanceModel {
//    var panel: Panel! { get set }
//}
//
//protocol WebLauncherInstanceProtocol: LauncherInstanceModel {
//    func checkUrl(url: URL) -> Bool
//}
//
//
//// Structure
//
//protocol AppController {
//    func getApp() -> URL?
//    func setApp(appUrl: URL, name: String?)
//    func iconForApp(size: Int) -> NSImage
//}
//
//protocol FileController {
//    func getFile() -> URL?
//    func setFile(fileUrl: URL, name: String?)
//}
//
//extension FileController {
//    func getCompatibleApps() -> [URL]? {
//        guard let cfURL = getFile() as CFURL? else { return nil }
//        
//        var URLs = [URL]()
//        
//        if let appURLs = LSCopyApplicationURLsForURL(cfURL, .all)?.takeRetainedValue() {
//            for url in appURLs as! [URL] {
//                URLs.append(url)
//            }
//        }
//        
//        return URLs
//    }
//}
//
//protocol Opener {
//    func openApp()
//}
//
//protocol Panel {
//    func createPanel() -> NSOpenPanel
//    
//    /// Open a panel for selecting a file, app or directory and return the selected file and whether the operation was completed (as opposed to cancelled by the user)
//    /// - Parameter panel: NSPanel
//    /// - Returns: 1) Selected file/directory's URL 2) Boolean indicating whether the file selection operation was completed
//    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool)
//}
//
//extension Panel {
//    // Upon further analysis (implementing this in different cases) it seems better to just extend NSOpenPanel and have a thing
//    // .canChooseApps and .canChooseFileFiles instead of just .canChooseFiles without distinguishing
//    // Upon further analysis.. actually not. You can't just extend default classes all the time.. gotta write soem regular code also no?
//    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
//        if panel.runModal() == .OK {
//            return (panel.url, true)
//        }
//        
//        return (nil, false)
//    }
//}

//// ------------------------
//// FolderLauncher
//// ------------------------
//struct FolderLauncherPanel: Panel {
//    var parent: LauncherInstanceDB
//
//    func createPanel() -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.canChooseDirectories = true
//            panel.canChooseFiles = false
//
//        return panel
//    }
//
//    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
//        var completedSelection = false
//
//        if panel.runModal() == .OK {
//            completedSelection = true
//
//            if let url = panel.url, url.hasDirectoryPath == true {
//                return (url, completedSelection)
//            }
//        }
//
//        return (nil, completedSelection)
//    }
//}
//
//// ------------------------
//// EmptyLauncher
//// ------------------------
//
//struct EmptyLauncherAppController: AppController {
//    var parent: LauncherInstanceDB
//
//    func getApp() -> URL? {
//        return nil
//    }
//
//    func setApp(name: String, appUrl: URL) {
//        let (thawed, realm) = parent.easyThaw()
//
//        try! realm.write {
//            thawed.name = name
//            thawed.appUrl = appUrl
//            thawed.instantiated = true
//        }
//    }
//
//    func iconForApp(size: Int) -> NSImage {
//        guard let image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil) else { fatalError("Failed to get icon") }
//
//        image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//}
//
//struct EmptyLauncherFileController: FileController {
//    var parent: LauncherInstanceDB
//
//    func getFile() -> URL? {
//        parent.fileUrl
//    }
//
//    func setFile(name: String, fileUrl: URL) {
//        let (thawed, realm) = parent.easyThaw()
//
//        try! realm.write {
//            thawed.name = name
//            thawed.fileUrl = fileUrl
//            thawed.instantiated = true
//        }
//    }
//}
//
//struct EmptyLauncherOpener: Opener {
//    var parent: LauncherInstanceDB
//
//    func openApp() {
//        print("You can't open this...")
//    }
//}
//
//struct EmptyLauncherPanel: Panel {
//    var parent: LauncherInstanceDB
//
//    func createPanel() -> NSOpenPanel {
//        fatalError("This doesn't work...")
//    }
//}
//
//// ------------------------
//// Website Launcher
//// ------------------------
//
//struct WebsiteLauncherAppController: AppController {
//    var parent: LauncherInstanceDB
//
//    var app: URL?
//
//    func getApp() -> URL? {
//        if let app = app
//        {
//            return app
//        }
//
//        return getDefaultApp()
//    }
//
//    func getDefaultApp() -> URL? {
//        if let file = parent.fileController.getFile() {
//            return NSWorkspace.shared.urlForApplication(toOpen: file)
//        }
//
//        return nil
//    }
//
//    func setApp(name: String, appUrl: URL) {
//        print("x")
//    }
//
//    func iconForApp(size: Int) -> NSImage {
//        let image: NSImage
//
//        if let app = getApp()
//        {
//            image = NSWorkspace.shared.icon(forFile: app.path)
//        }
//        else
//        {
//            image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil)!
//        }
//
//        image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//}
//
//struct WebsiteLauncherFileController: FileController {
//    var parent: LauncherInstanceDB
//
//    func getFile() -> URL? {
//        if let filePath = parent.filePath
//        {
//            return URL(string: filePath)
//        }
//
//        return nil
//    }
//
//    func setFile(name: String, fileUrl: URL) {
//        let (instance, realm) = parent.easyThaw()
//
//        try! realm.write {
//            instance.name = name
//            instance.fileUrl = fileUrl
//            instance.instantiated = true
//        }
//    }
//}
//
//struct WebsiteLauncherOpener: Opener {
//    var parent: LauncherInstanceDB
//
//    func openApp() {
//        guard let file = parent.fileController.getFile() else { return }
//
//        let config = NSWorkspace.OpenConfiguration()
//            config.activates = true
//            config.hides = parent.hideOnLaunch
//
//        NSWorkspace.shared.open(file)
//    }
//}
//
//struct WebsiteLauncherPanel: Panel {
//    var parent: LauncherInstanceDB
//
//    func createPanel() -> NSOpenPanel {
//        fatalError("Yeah.. no")
//    }
//
//    func openPanel(with panel: NSOpenPanel) -> Bool {
//        fatalError("Yeah.. no again")
//    }
//}














//protocol BaseLauncherProtocol {
//    var name: String { get }
//    var icon: NSImage { get }
//}
//
//struct BaseLauncher: BaseLauncherProtocol {
//    let name = "New App"
//    let icon = NSImage(named: "heart.fill")!
//}
//
//protocol FileSystemLauncher {
//    var baseLauncher: BaseLauncher { get set }
//    var opener: Opener { get set }
//
//    func getApp() -> URL
//    func setApp()
//}
//
//struct AppBasedLauncher {
//    var fileSystemLauncher: FileSystemLauncher
//
//    func getApp() -> URL
//    func setApp()
//}
//
//struct FileBasedLauncher {
//    var fileSystemLauncher: FileSystemLauncher
//
//    func getApp() -> URL
//    func setApp()
//}
