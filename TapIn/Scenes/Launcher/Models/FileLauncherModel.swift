import Foundation
import Cocoa


struct BaseFileLauncher: FileSystemBasedBehavior {
    // FileSystemBasedBehavior
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
            
            if let url = panel.url, url.pathExtension != "app" && url.hasDirectoryPath == false {
                return (url, completedSelection)
            }
        }
        
        return (nil, completedSelection)
    }
}

struct UninstantiatedFileLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior {
    let id = UUID()
    var object: LauncherInstanceDB
    
    init(instance: LauncherInstanceDB) {
        self.object = instance
    }
    
    let base = BaseFileLauncher()
    let type = RealmLauncherType.file
    
    func createPanel() -> NSOpenPanel {
        return base.createPanel()
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        return base.openPanel(with: panel)
    }
}

struct InstantiatedFileLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior, FileBehavior, Openable {
    let id = UUID()
    
    init(instance: LauncherInstanceDB) {
        self.object = instance
        self.file = object.fileUrl!
    }
    
    var object: LauncherInstanceDB
    var file: URL
    let type = RealmLauncherType.file
    let base = BaseFileLauncher()
    
    var app: URL? {
        return object.appUrl ?? getDefaultApp(fileUrl: file)
    }
    
    var name: String {
        object.name
    }
    
    // DisplayableBehavior
    
    func getIcon(size: Int) -> NSImage {
        guard let app = app else {
            return getAbsentAppIcon(size: size)
        }
        
        return getAppIcon(for: app, size: 40)
    }

    // FileSystemBasedBehavior
    
    func createPanel() -> NSOpenPanel {
        return base.createPanel()
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        return base.openPanel(with: panel)
    }
    
    // Openable
    
    func open() {
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            config.hides = object.hideOnLaunch
        
        if let app = app
        {
            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config)
        }
        else
        {
            NSWorkspace.shared.open(file, configuration: config)
        }
    }
}
























//import Foundation
//import Cocoa
//
//struct FileLauncher: FileSystemLauncherInstanceProtocol {
//    var appController: AppController!
//    var fileController: FileController!
//    var opener: Opener!
//    var panel: Panel!
//    var object: LauncherInstanceDB
//
//    init(_ instance: LauncherInstanceDB) {
//        self.object = instance
//
//        guard let file = object.fileUrl else {
//            fatalError("Error 1382573249")
//        }
//
//        self.appController = FileBasedAppController(parent: self)
//        self.fileController = FileBasedFileController(file: file)
//        self.opener = FileBasedOpener(parent: self)
//        self.panel = FileBasedPanel()
//    }
//}
//
//// ------------------------
//// AppLauncher
//// ------------------------
//
//struct FileBasedAppController: AppController {
//    var parent: FileSystemLauncherInstanceProtocol
//
//    func getApp() -> URL? {
//        if let app = parent.app
//        {
//            return app
//        }
//        else
//        {
//            return getDefaultApp(fileUrl: parent.file!)
//        }
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
//struct FileBasedFileController: FileController {
//    var file: URL
//
//    func getFile() -> URL? {
//        return file
//    }
//
//    func setFile(fileUrl: URL, name: String?) {
//
//    }
//}
//
//struct FileBasedOpener: Opener {
//    var parent: FileSystemLauncherInstanceProtocol
//
//    func openApp() {
//        let file = parent.fileController.getFile()!
//        let hideOnLaunch = parent.object.hideOnLaunch
//
//        let config = NSWorkspace.OpenConfiguration()
//            config.activates = true
//            config.hides = hideOnLaunch
//
//        if let app = parent.appController.getApp()
//        {
//            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config)
//        }
//        else
//        {
//            NSWorkspace.shared.open(file, configuration: config)
//        }
//    }
//}
//
//struct FileBasedPanel: Panel {
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
//            if let url = panel.url, url.pathExtension != "app" && url.hasDirectoryPath == false {
//                return (url, completedSelection)
//            }
//        }
//
//        return (nil, completedSelection)
//    }
//}

