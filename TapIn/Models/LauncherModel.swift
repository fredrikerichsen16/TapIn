//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

struct LauncherModel {
    var selected: LaunchInstance? = nil
    var instances: [IdentifiableLaunchInstance] = []
    
    init() {
        let craftURL = URL(fileURLWithPath: "/Applications/Craft.app")
        let notesURL = URL(fileURLWithPath: "/Applications/Notes.app")
        
        createAppLaunchInstance(name: "Craft", app: craftURL, file: nil)
        createAppLaunchInstance(name: "Notes", app: notesURL, file: nil)
    }
    
    mutating func createAppLaunchInstance(name: String, app: URL, file: URL?) {
        let instance = AppLauncher(name: name, app: app, file: file)
        let identifiable = IdentifiableLaunchInstance(launchInstance: instance)
        instances.append(identifiable)
    }
    
    mutating func createFileLaunchInstance(name: String, file: URL, app: URL?) {
        let instance = FileLauncher(name: name, file: file, app: app)
        let identifiable = IdentifiableLaunchInstance(launchInstance: instance)
        instances.append(identifiable)
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

enum LauncherTypes {
    case app
    case file
    case folder
    case website
}

protocol LaunchInstance {
    var name: String { get set }
    
    func mainIcon(size: Int) -> NSImage
    func launch()
}

struct AppLauncher: LaunchInstance {
    var name: String
    var app: URL
    var file: URL?
    
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
}

struct FileLauncher: LaunchInstance {
    var name: String
    var file: URL
    var app: URL?
    
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
    
    func mainIcon(size: Int) -> NSImage {
        let image = NSWorkspace.shared.icon(forFile: file.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func launch() {
        let app = getApp()
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
        
        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
            print(file)
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
