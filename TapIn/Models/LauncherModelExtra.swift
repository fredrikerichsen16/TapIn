//
//  LauncherModelExtra.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import Cocoa
import RealmSwift

// ------------------------
// GENERAL PURPOSE
// ------------------------

// Helpers

func applicationReadableName(url: URL) -> String {
   return FileManager.default.displayName(atPath: url.path)
}

func getAppIcon(for app: URL, size: Int) -> NSImage {
    let image = NSWorkspace.shared.icon(forFile: app.path)
        image.size = NSSize(width: size, height: size)
    
    return image
}

// Structure

enum LauncherType: Equatable {
    case app
    case file
    case folder
    case website
    case terminal
    indirect case empty(LauncherType)

    func label() -> String {
        switch self {
        case .empty(let type):
            return type.label()
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
}

protocol AppController {
    var parent: LauncherInstanceDB { get set }
    
    func getApp() -> URL?
    func setApp(name: String, appPath: String)
    
    func iconForApp(size: Int) -> NSImage
    
    func getDefaultApp() -> URL?
}

extension AppController {
    func getDefaultApp() -> URL? {
        let file = parent.fileUrl!
        
        return NSWorkspace.shared.urlForApplication(toOpen: file)
    }
}

protocol FileController {
    var parent: LauncherInstanceDB { get set }
    
    func getFile() -> URL?
    func setFile(name: String, filePath: String)
}

extension FileController {
    func getCompatibleApps() -> [URL]? {
        guard let cfURL = getFile() as CFURL? else { return nil }
        
        var URLs = [URL]()
        
        if let appURLs = LSCopyApplicationURLsForURL(cfURL, .all)?.takeRetainedValue() {
            for url in appURLs as! [URL] {
                URLs.append(url)
            }
        }
        
        return URLs
    }
}

protocol Opener {
    var parent: LauncherInstanceDB { get set }
    
    func openApp()
}

protocol Panel {
    var parent: LauncherInstanceDB { get set }
    
    func createPanel() -> NSOpenPanel
    
    /// Open a panel for selecting a file, app or directory and return the selected file and whether the operation was completed (as opposed to cancelled by the user)
    /// - Parameter panel: NSPanel
    /// - Returns: 1) Selected file/directory's URL 2) Boolean indicating whether the file selection operation was completed
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool)
}

extension Panel {
    // Upon further analysis (implementing this in different cases) it seems better to just extend NSOpenPanel and have a thing
    // .canChooseApps and .canChooseFileFiles instead of just .canChooseFiles without distinguishing
    // Upon further analysis.. actually not. You can't just extend default classes all the time.. gotta write soem regular code also no?
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        if panel.runModal() == .OK {
            return (panel.url, true)
        }
        
        return (nil, false)
    }
}

// ------------------------
// AppLauncher
// ------------------------

struct AppLauncherAppController: AppController {
    var parent: LauncherInstanceDB
    
    func getApp() -> URL? {
        return parent.appUrl
    }
    
    func setApp(name: String, appPath: String) {
        let (thawed, realm) = parent.easyThaw()

        try! realm.write {
            thawed.name = name
            thawed.appPath = appPath
            thawed.instantiated = true
        }
    }
  
    func iconForApp(size: Int) -> NSImage {
        guard let app = getApp() else { fatalError("App has to have an app.. duh") }
        
        let image = NSWorkspace.shared.icon(forFile: app.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct AppLauncherFileController: FileController {
    var parent: LauncherInstanceDB
    
    func getFile() -> URL? {
        parent.fileUrl
    }
    
    func setFile(name: String, filePath: String) {
        print("y")
    }
}

struct AppLauncherOpener: Opener {
    var parent: LauncherInstanceDB
    
    func openApp() {
        let app = parent.appUrl!
        
        if let file = parent.fileUrl
        {
            let config = NSWorkspace.OpenConfiguration()
                config.activates = true
                config.hides = parent.hideOnLaunch
            
            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
                print(app as Any)
            }
        }
        else
        {
            let config = NSWorkspace.OpenConfiguration()
                config.activates = true
                config.hides = parent.hideOnLaunch
            
            NSWorkspace.shared.openApplication(at: app, configuration: config, completionHandler: { _, _ in
                print("OPENED APP")
            })
        }
    }
}

struct AppLauncherPanel: Panel {
    var parent: LauncherInstanceDB
    
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

// ------------------------
// FileLauncher
// ------------------------

struct FileLauncherAppController: AppController {
    var parent: LauncherInstanceDB
    
    func getApp() -> URL? {
        if let app = parent.appUrl
        {
            return app
        }
        
        return getDefaultApp()
    }
    
    func setApp(name: String, appPath: String) {
        print("x")
    }
    
    func iconForApp(size: Int) -> NSImage {
        var image: NSImage
        
        if let _app = getApp() {
            image = NSWorkspace.shared.icon(forFile: _app.path)
        } else {
            image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil)!
        }
        
        image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct FileLauncherFileController: FileController {
    var parent: LauncherInstanceDB
    
    func getFile() -> URL? {
        parent.fileUrl
    }
    
    func setFile(name: String, filePath: String) {
        let (thawed, realm) = parent.easyThaw()

        try! realm.write {
            thawed.name = name
            thawed.filePath = filePath
            thawed.instantiated = true
        }
    }
}

struct FileLauncherOpener: Opener {
    var parent: LauncherInstanceDB
    
    func openApp() {
        guard let app = parent.appController.getApp() else {
            print("ERROR 194324")
            return
        }
        
        let file = parent.fileUrl!
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            config.hides = parent.hideOnLaunch
        
        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
            print(file)
        }
    }
}

struct FileLauncherPanel: Panel {
    var parent: LauncherInstanceDB
    
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
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

// ------------------------
// FolderLauncher
// ------------------------
struct FolderLauncherPanel: Panel {
    var parent: LauncherInstanceDB
    
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
        
        return panel
    }
    
    func openPanel(with panel: NSOpenPanel) -> (URL?, Bool) {
        var completedSelection = false
        
        if panel.runModal() == .OK {
            completedSelection = true
            
            if let url = panel.url, url.hasDirectoryPath == true {
                return (url, completedSelection)
            }
        }
        
        return (nil, completedSelection)
    }
}

// ------------------------
// EmptyLauncher
// ------------------------

struct EmptyLauncherAppController: AppController {
    var parent: LauncherInstanceDB

    func getApp() -> URL? {
        return getDefaultApp()
    }
    
    func setApp(name: String, appPath: String) {
        let (thawed, realm) = parent.easyThaw()

        try! realm.write {
            thawed.name = name
            thawed.appPath = appPath
            thawed.instantiated = true
        }
    }
    
    func iconForApp(size: Int) -> NSImage {
        guard let image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil) else { fatalError("Failed to get icon") }
        
        image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct EmptyLauncherFileController: FileController {
    var parent: LauncherInstanceDB
    
    func getFile() -> URL? {
        parent.fileUrl
    }
    
    func setFile(name: String, filePath: String) {
        let (thawed, realm) = parent.easyThaw()

        try! realm.write {
            thawed.name = name
            thawed.filePath = filePath
            thawed.instantiated = true
        }
    }
}

struct EmptyLauncherOpener: Opener {
    var parent: LauncherInstanceDB
    
    func openApp() {
        print("You can't open this...")
    }
}

struct EmptyLauncherPanel: Panel {
    var parent: LauncherInstanceDB
    
    func createPanel() -> NSOpenPanel {
        fatalError("This doesn't work...")
    }
}

// ------------------------
// Website Launcher
// ------------------------

struct WebsiteLauncherAppController: AppController {
    var parent: LauncherInstanceDB
    
    var app: URL?
    
    func getApp() -> URL? {
        if let app = app
        {
            return app
        }
        
        return getDefaultApp()
    }
    
    func getDefaultApp() -> URL? {
        if let file = parent.fileController.getFile() {
            return NSWorkspace.shared.urlForApplication(toOpen: file)
        }
        
        return nil
    }
    
    func setApp(name: String, appPath: String) {
        print("x")
    }
    
    func iconForApp(size: Int) -> NSImage {
        var image: NSImage
        
        if let _app = getApp()
        {
            image = NSWorkspace.shared.icon(forFile: _app.path)
        }
        else
        {
            image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil)!
        }
        
        image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct WebsiteLauncherFileController: FileController {
    var parent: LauncherInstanceDB
    
    func getFile() -> URL? {
        if let filePath = parent.filePath
        {
            return URL(string: filePath)
        }
        
        return nil
    }
    
    func setFile(name: String, filePath: String) {
        let (thawed, realm) = parent.easyThaw()

        try! realm.write {
            thawed.name = name
            thawed.filePath = filePath
            thawed.instantiated = true
        }
    }
}

struct WebsiteLauncherOpener: Opener {
    var parent: LauncherInstanceDB
    
    func openApp() {
        guard let file = parent.fileController.getFile() else { return }
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
            config.hides = parent.hideOnLaunch
        
        NSWorkspace.shared.open(file)
    }
}

struct WebsiteLauncherPanel: Panel {
    var parent: LauncherInstanceDB
    
    func createPanel() -> NSOpenPanel {
        fatalError("Yeah.. no")
    }
    
    func openPanel(with panel: NSOpenPanel) -> Bool {
        fatalError("Yeah.. no again")
    }
}
