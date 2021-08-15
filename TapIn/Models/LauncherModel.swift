//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

struct LauncherModel {
    var instances: [LaunchInstance] = []
    
    init() {
        let craftURL = URL(fileURLWithPath: "/Applications/Craft.app")
        let spotifyURL = URL(fileURLWithPath: "/Applications/Spotify.app")
        let screenshotURL = URL(fileURLWithPath: "/Users/fredrik/Desktop/Screenshot.png")
        
        createAppLaunchInstance(name: "Craft", app: craftURL, file: nil)
        createAppLaunchInstance(name: "Spotify", app: spotifyURL, file: nil)
        createFileLaunchInstance(name: "Screenshot", file: screenshotURL, app: nil)
    }
    
    mutating func createEmptyLaunchInstance(type: LauncherType) {
        let instance = EmptyInstance(type: type)
        instances.append(instance)
    }
    
    mutating func createAppLaunchInstance(name: String, app: URL, file: URL?) {
        let instance = AppLauncher(name: name, app: app, file: file)
        instances.append(instance)
    }
    
    mutating func createFileLaunchInstance(name: String, file: URL, app: URL?) {
        let instance = FileLauncher(name: name, file: file, app: app)
        instances.append(instance)
    }
}

struct IdentifiableLaunchInstance: Identifiable {
    var id = UUID()
    var launchInstance: LaunchInstance
}

// - Add, remove, rename instance
// - Add file, app, terminal, folder, etc.
//  - have check type method
// -

enum LauncherType: String {
    case app = "App"
    case file = "File"
    case folder = "Folder"
    case website = "Website"
}

protocol LaunchInstance {
    var name: String { get set }
    
    func mainIcon(size: Int) -> NSImage
    func launch()
}

extension LaunchInstance {
    static func iconForApp(app url: URL, size: Int) -> NSImage {
        let image = NSWorkspace.shared.icon(forFile: url.path)
            image.size = NSSize(width: size, height: size)
            
        return image
    }
    
    static func panelForLauncherType(type: LauncherType) -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
        
        if type == .website {
            fatalError("Can't get panel for website type")
        }
        
        switch type {
            case .app:
                panel.canChooseDirectories = false
                panel.canChooseFiles = true
                panel.allowedFileTypes = ["app"]
            case .file:
                panel.canChooseDirectories = false
                panel.canChooseFiles = true
            case .folder:
                panel.canChooseDirectories = true
                panel.canChooseFiles = false
            default:
                panel.canChooseFiles = true
                panel.canChooseDirectories = true
        }
        
        return panel
    }
}

struct EmptyInstance: LaunchInstance {
    var type: LauncherType
    var name: String
    
    init(type: LauncherType) {
        self.type = type
        self.name = type.rawValue
    }
    
    func instructionText() -> String {
        switch type {
            case .app:
                return "Drop an app here"
            case .file:
                return "Drop a file here"
            case .folder:
                return "Drop a folder here"
            case .website:
                return "Drag a website here or type in a link below"
        }
    }
    
    func mainIcon(size: Int) -> NSImage {
        let image = NSImage(systemSymbolName: "questionmark.diamond.fill", accessibilityDescription: nil)!
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func launch() {
        print("Can't launch")
    }
}

struct AppLauncher: LaunchInstance {
    var name: String
    var app: URL
    var file: URL?
    
    init(name: String, app: URL, file: URL?) {
        self.name = name
        self.app = app
        self.file = file
    }
    
    func mainIcon(size: Int) -> NSImage {
        let image = NSWorkspace.shared.icon(forFile: app.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func launch() {
        if let file = file
        {
            let config = NSWorkspace.OpenConfiguration()
                config.activates = true
            
            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
                print(app)
            }
        }
        else
        {
            NSWorkspace.shared.open(app)
        }
    }
    
    static func applicationName(url: URL) -> String {
        return FileManager.default.displayName(atPath: url.path)
    }
}

struct FileLauncher: LaunchInstance {
    var name: String
    var file: URL
    var app: URL?
    
    init(name: String, file: URL, app: URL?) {
        self.name = name
        self.file = file
        self.app = app
    }
    
    func getApp() -> URL {
        if let app = app
        {
            return app
        }
        
        if let defaultApp = NSWorkspace.shared.urlForApplication(toOpen: file)
        {
            return defaultApp
        }
        else
        {
            fatalError("No set app nor default app found to open file \(file.path)")
        }
    }
    
    mutating func setApp(_ url: URL) {
        app = url
    }
    
    func mainIcon(size: Int) -> NSImage {
        let iconForPath = app == nil ? file.path : app!.path
        
        let image = NSWorkspace.shared.icon(forFile: iconForPath)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func launch() {
        let app = getApp()
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
        
        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
            print(self.file)
        }
    }
    
    func getCompatibleApps() -> [URL] {
        let cfURL = file as CFURL
        
        var URLs = [URL]()
        
        if let appURLs = LSCopyApplicationURLsForURL(cfURL, .all)?.takeRetainedValue() {
            for url in appURLs as! [URL] {
                URLs.append(url)
            }
        }
        
        return URLs
    }
}

//struct LaunchInstance: Identifiable {
//    var id = UUID()
//    var name: String
//    var app: URL?
//    var file: URL?
//    var appFirst: Bool = true
//
//    func getApp() -> URL {
//        if let app = app
//        {
//            return app
//        }
//        else
//        {
//            return getDefaultApp()
//        }
//    }
//
//    init(name: String, appFirst: Bool, app: URL?, file: URL?) {
//        self.name = name
//        self.appFirst = appFirst
//        self.app = app
//        self.file = file
//    }
//
//    func getAppIcon(size: Int = 80) -> NSImage {
//        let app = getApp()
//        let image = NSWorkspace.shared.icon(forFile: app.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    func getFileIcon(size: Int = 80) -> NSImage? {
//        if let file = file
//        {
//            let image = NSWorkspace.shared.icon(forFile: file.path)
//                image.size = NSSize(width: size, height: size)
//
//            return image
//        }
//
//        return nil
//    }
//
////    static func getIcon(for url: URL, size: Int = 80) -> NSImage {
////        let image: NSImage = NSWorkspace.shared.icon(forFile: url.path)
////            image.size = NSSize(width: size, height: size)
////
////        return image
////    }
//
//    func getDefaultApp() -> URL {
//        if file != nil,
//           let defaultApp = NSWorkspace.shared.urlForApplication(toOpen: file!)
//        {
//            return defaultApp
//        }
//        else
//        {
//            return URL(fileURLWithPath: "/Applications/Notes.app")
//        }
//    }
//
//    func getCompatibleApps() -> [URL] {
//        guard file != nil else { fatalError("File is not defined") }
//
//        let cfUrl = file! as CFURL
//
//        var URLs: [URL] = []
//
//        if let appURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue()
//        {
//            for url in appURLs as! [URL] {
//                URLs.append(url)
//            }
//        }
//
//        return URLs
//    }
//
//    func open() {
//        if file != nil
//        {
//            let config = NSWorkspace.OpenConfiguration()
//                config.activates = true
//
//            NSWorkspace.shared.open([file!], withApplicationAt: getApp(), configuration: config) { (app, error) in
//                print(app)
//            }
//        }
//        else
//        {
//            NSWorkspace.shared.open(getApp())
//        }
//    }
//
//    func urlInfo(for url: URL) {
//        print("""
//            - Path: \(url.path)
//            - Is directory?: \(url.hasDirectoryPath)
//            - Is file?: \(url.isFileURL)
//            - Scheme: \(url.scheme)
//            - Last Path Component: \(url.lastPathComponent)
//            - Extension: \(url.pathExtension)
//            - File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
//            - urlForApp: \(NSWorkspace.shared.urlForApplication(toOpen: url))
//        """)
//    }
//}
