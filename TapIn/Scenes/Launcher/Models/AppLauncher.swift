import Foundation
import Cocoa

struct BaseAppLauncher {
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
        
        return panel
    }

    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        var completedSelection = false
        
        if panel.runModal() == .OK {
            completedSelection = true
            
            if let url = panel.url, url.pathExtension == "app" {
                return (url, completedSelection)
            }
        }
        
        return (nil, completedSelection)
    }
}

struct UninstantiatedAppLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior {
    init(instance: LauncherInstanceDB) {
        self.object = instance
    }
    
    var object: LauncherInstanceDB
    let base = BaseAppLauncher()
    let type = RealmLauncherType.app
    
    // FileSystemBasedBehavior
    
    func createPanel() -> NSOpenPanel {
        return base.createPanel()
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        return base.openPanel(with: panel)
    }
    
    func submittedFileWithPanel(url: URL) {
        print(url)
        update(app: url, file: nil)
    }
}

struct InstantiatedAppLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior, Openable, AppBehavior {
    init(instance: LauncherInstanceDB) {
        self.object = instance
        self.app = object.appUrl!
    }
    
    var object: LauncherInstanceDB
    var app: URL
    let type = RealmLauncherType.app
    let base = BaseAppLauncher()
    
    var name: String {
        object.name
    }
    
    // DisplayableBehavior
    
    func getIcon(size: Int) -> NSImage {
        return getAppIcon(for: app, size: size)
    }
    
    // FileSystemBasedBehavior
    
    func createPanel() -> NSOpenPanel {
        return base.createPanel()
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        return base.openPanel(with: panel)
    }
    
    func submittedFileWithPanel(url: URL) {
        update(app: url, file: nil)
    }

    // Openable
    
    func open() {
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            config.hides = object.hideOnLaunch
        
        NSWorkspace.shared.openApplication(at: app, configuration: config)
    }
}
















//import Foundation
//import Cocoa
//
//struct AppLauncher: FileSystemLauncherInstanceProtocol {
//    var appController: AppController!
//    var fileController: FileController!
//    var panel: Panel!
//    var opener: Opener!
//    var object: LauncherInstanceDB
//
//    init(_ instance: LauncherInstanceDB) {
//        self.object = instance
//
//        self.appController = AppLauncherAppController(parent: self)
//        self.fileController = AppLauncherFileController()
//        self.panel = AppLauncherPanel()
//        self.opener = AppLauncherOpener(app: object.appUrl!, hideOnLaunch: object.hideOnLaunch)
//    }
//}
//
//// ------------------------
//// AppLauncher
//// ------------------------
//
//struct AppLauncherAppController: AppController {
//    var parent: AppLauncher!
//
//    func getApp() -> URL? {
//        return parent.app
//    }
//
//    func setApp(appUrl: URL, name: String? = nil) {
//        guard let instance = parent.object.thaw() else {
//            return
//        }
//
//        let name = name != nil ? name! : applicationReadableName(url: appUrl)
//
//        try? RealmManager.shared.realm.write {
//            instance.name = name
//            instance.appUrl = appUrl
//            instance.instantiated = true
//        }
//    }
//
//    func iconForApp(size: Int) -> NSImage {
//        guard let app = getApp() else { fatalError("App has to have an app.. duh") }
//
//        let image = NSWorkspace.shared.icon(forFile: app.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//}
//
//struct AppLauncherFileController: FileController {
//    func getFile() -> URL? {
//        return nil
//    }
//
//    func setFile(fileUrl: URL, name: String? = nil) {}
//}
//
//struct AppLauncherOpener: Opener {
//    var app: URL
//    var hideOnLaunch: Bool
//
//    func openApp() {
//        let config = NSWorkspace.OpenConfiguration()
//            config.activates = true
//            config.hides = hideOnLaunch
//
//        NSWorkspace.shared.openApplication(at: app, configuration: config)
//    }
//}
//
//struct AppLauncherPanel: Panel {
//    func createPanel() -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.allowsMultipleSelection = false
//            panel.canChooseDirectories = false
//            panel.canChooseFiles = true
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
//            if let url = panel.url, url.pathExtension == "app" {
//                return (url, completedSelection)
//            }
//        }
//
//        return (nil, completedSelection)
//    }
//}
