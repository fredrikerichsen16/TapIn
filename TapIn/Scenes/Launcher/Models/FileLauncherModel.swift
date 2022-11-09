import Foundation
import Cocoa

struct BaseFileLauncher {
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
//    let id = UUID()
    
    init(instance: LauncherInstanceDB) {
        self.object = instance
    }
    
    var object: LauncherInstanceDB
    let base = BaseFileLauncher()
    let type = RealmLauncherType.file
    
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

struct InstantiatedFileLauncher: BaseLauncherInstanceBehavior, FileSystemBasedBehavior, FileBehavior, Openable {
//    let id = UUID()
    
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
