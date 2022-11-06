import Foundation
import Cocoa

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
