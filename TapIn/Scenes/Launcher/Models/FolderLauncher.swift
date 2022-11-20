import Foundation
import Cocoa


struct BaseFolderLauncher {
    // FileSystemBasedBehavior
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
        
        return panel
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        var completedSelection = false
        
        if panel.runModal() == .OK {
            completedSelection = true
            
            if let url = panel.url, url.hasDirectoryPath  {
                return (url, completedSelection)
            }
        }
        
        return (nil, completedSelection)
    }
}

struct UninstantiatedFolderLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior {
//    let id = UUID()

    init(instance: LauncherInstanceDB) {
        self.object = instance
    }

    var object: LauncherInstanceDB
    let base = BaseFolderLauncher()
    let type = RealmLauncherType.folder
    
    // FileSystemBasedBehavior
    
    func createPanel() -> NSOpenPanel {
        return base.createPanel()
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        return base.openPanel(with: panel)
    }
    
    func submittedFileWithPanel(url: URL) {
        update(app: nil, file: url)
    }
}

struct InstantiatedFolderLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior, FileBehavior, Openable {
//    let id = UUID()
    
    init(instance: LauncherInstanceDB) {
        self.object = instance
        self.file = object.fileUrl!
    }
    
    var object: LauncherInstanceDB
    var file: URL
    let type = RealmLauncherType.file
    let base = BaseFolderLauncher()
    
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
        update(app: nil, file: url)
    }
    
    // FileBehavior
    
    func getCompatibleApps() -> [URL] {
        let cfURL = file as CFURL
        
        var URLs: [URL] = []
        
        if let appUrls = LSCopyApplicationURLsForURL(cfURL, .all)?.takeRetainedValue() {
            for url in appUrls as! [URL] {
                URLs.append(url)
            }
            
            if let terminalApp = URL(string: "file:///System/Applications/Utilities/Terminal.app") {
                URLs.append(terminalApp)
            }
        }
        
        return URLs
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

































//struct FolderLauncher: FileSystemLauncherInstanceProtocol {
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
//        self.appController = FolderBasedAppController(parent: self)
//        self.fileController = FileBasedFileController(file: file)
//        self.opener = FileBasedOpener(parent: self)
//        self.panel = FolderBasedPanel()
//        
//    }
//}
//
//// ------------------------
//// AppLauncher
//// ------------------------
//
//struct FolderBasedAppController: AppController {
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
//struct FolderBasedPanel: Panel {
//    func createPanel() -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.allowsMultipleSelection = false
//            panel.canChooseDirectories = true
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
//            if let url = panel.url, url.hasDirectoryPath {
//                return (url, completedSelection)
//            }
//        }
//        
//        return (nil, completedSelection)
//    }
//}
