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
    var parent: LaunchInstanceBridge { get set }

    var app: URL? { get set }
    
    func getApp() -> URL?
    func setApp()
    
    func iconForApp(size: Int) -> NSImage
    
    func getDefaultApp() -> URL?
}

extension AppController {
    func getDefaultApp() -> URL? {
        let file = parent.fileController.file!
        
        return NSWorkspace.shared.urlForApplication(toOpen: file)
    }
}

protocol FileController {
    var parent: LaunchInstanceBridge { get set }
    
    var file: URL? { get set }
    
    func getFile()
    func setFile()
}

extension FileController {
    func getCompatibleApps() -> [URL]? {
        guard let cfURL = file as CFURL? else { return nil }
        
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
    var parent: LaunchInstanceBridge { get set }
    
    func openApp()
}

protocol Panel {
    var parent: LaunchInstanceBridge { get set }
    
    func createPanel() -> NSOpenPanel
    func openPanel(with panel: NSOpenPanel) -> Bool
}

extension Panel {
    // Upon further analysis (implementing this in different cases) it seems better to just extend NSOpenPanel and have a thing
    // .canChooseApps and .canChooseFileFiles instead of just .canChooseFiles without distinguishing
    // Upon further analysis.. actually not. You can't just extend default classes all the time.. gotta write soem regular code also no?
    func openPanel(with panel: NSOpenPanel) -> Bool {
        return panel.runModal() == .OK
    }
}

class LaunchInstanceBridge {
    init(name: String, type: LauncherType) {
        self.name = name
        self.type = type
    }
    
    func initializeBridge(appController: AppController,
                          fileController: FileController,
                          opener: Opener,
                          panel: Panel) {
        self.appController = appController
        self.fileController = fileController
        self.opener = opener
        self.panel = panel
    }
    
    var name: String
    var type: LauncherType
    var fileController: FileController!
    var appController: AppController!
    var opener: Opener!
    var panel: Panel!
    
//    func instructionText() -> String {
//        switch type {
//            case .app:
//                return "Drop an app here"
//            case .file:
//                return "Drop a file here"
//            case .folder:
//                return "Drop a folder here"
//            case .website:
//                return "Drag a website here or type in a link below"
//            case .terminal:
//                return "Drag a folder here"
//        }
//    }
    
    // Creation
    
    static func createEmptyLauncher(type: LauncherType) -> LaunchInstanceBridge {
        let emptyLauncher = LaunchInstanceBridge(
            name: "New \(type)",
            type: .empty(type)
        )
        
        var typeConformingPanel: Panel
        
        switch type {
            case .app:
                typeConformingPanel = AppLauncherPanel(parent: emptyLauncher)
            case .file:
                typeConformingPanel = FileLauncherPanel(parent: emptyLauncher)
            case .folder:
                typeConformingPanel = FolderLauncherPanel(parent: emptyLauncher)
            case .website:
                typeConformingPanel = WebsiteLauncherPanel(parent: emptyLauncher)
            case .empty(_):
                typeConformingPanel = EmptyLauncherPanel(parent: emptyLauncher)
            default:
                fatalError("Not yet fully supported type")
        }

        emptyLauncher.initializeBridge(
            appController: EmptyLauncherAppController(parent: emptyLauncher, app: nil),
            fileController: EmptyLauncherFileController(parent: emptyLauncher, file: nil),
            opener: EmptyLauncherOpener(parent: emptyLauncher),
            panel: typeConformingPanel
        )
        
        return emptyLauncher
    }
    
    static func createAppLauncher(name: String, app: URL, file: URL?) -> LaunchInstanceBridge {
        let appLauncher = LaunchInstanceBridge(
            name: name,
            type: .app
        )

        appLauncher.initializeBridge(
            appController: AppLauncherAppController(parent: appLauncher, app: app),
            fileController: AppLauncherFileController(parent: appLauncher, file: file),
            opener: AppLauncherOpener(parent: appLauncher),
            panel: AppLauncherPanel(parent: appLauncher)
        )
        
        return appLauncher
    }
    
    static func createFileLauncher(name: String, file: URL, app: URL?) -> LaunchInstanceBridge {
        let fileLauncher = LaunchInstanceBridge(
            name: name,
            type: .file
        )

        fileLauncher.initializeBridge(
            appController: FileLauncherAppController(parent: fileLauncher, app: app),
            fileController: FileLauncherFileController(parent: fileLauncher, file: file),
            opener: FileLauncherOpener(parent: fileLauncher),
            panel: FileLauncherPanel(parent: fileLauncher)
        )
        
        return fileLauncher
    }
    
    static func createFolderLauncher(name: String, file: URL, app: URL?) -> LaunchInstanceBridge {
        let folderLauncher = LaunchInstanceBridge(
            name: name,
            type: .folder
        )

        folderLauncher.initializeBridge(
            appController: FileLauncherAppController(parent: folderLauncher, app: app),
            fileController: FileLauncherFileController(parent: folderLauncher, file: file),
            opener: FileLauncherOpener(parent: folderLauncher),
            panel: FolderLauncherPanel(parent: folderLauncher)
        )
        
        return folderLauncher
    }
    
    static func createWebsiteLauncher(name: String, file: URL, app: URL?) -> LaunchInstanceBridge {
        let websiteLauncher = LaunchInstanceBridge(
            name: name,
            type: .website
        )

        websiteLauncher.initializeBridge(
            appController: WebsiteLauncherAppController(parent: websiteLauncher, app: app),
            fileController: WebsiteLauncherFileController(parent: websiteLauncher, file: file),
            opener: WebsiteLauncherOpener(parent: websiteLauncher),
            panel: WebsiteLauncherPanel(parent: websiteLauncher)
        )
        
        return websiteLauncher
    }
    
    // Convert from empty to type basically
    static func createLauncherFromType(type emptyType: LauncherType, name: String, app: URL?, file: URL?) -> LaunchInstanceBridge? {
//        guard case let .empty(type) = emptyType else { return nil }
        
        var type = emptyType
        
        if case let .empty(innerType) = emptyType {
            type = innerType
        }
        
        switch type {
            case .app:
                guard let _app = app else { return nil }
                return createAppLauncher(name: name, app: _app, file: file)
            case .file:
                guard let _file = file else { return nil }
                return createFileLauncher(name: name, file: _file, app: app)
            case .folder:
                guard let _file = file else { return nil }
                return createFileLauncher(name: name, file: _file, app: app)
            case .website:
                guard let _file = file else { return nil }
                return createWebsiteLauncher(name: name, file: _file, app: app)
            default:
                return nil
        }
    }

}

// ------------------------
// AppLauncher
// ------------------------
struct AppLauncherAppController: AppController {
    var parent: LaunchInstanceBridge
    
    var app: URL?
    
    func getApp() -> URL? {
        print("x")
        return nil
    }
    
    func setApp() {
        print("x")
    }
    
    func iconForApp(size: Int) -> NSImage {
        guard let app = app else { fatalError("App has to have an app.. duh") }
        
        let image = NSWorkspace.shared.icon(forFile: app.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct AppLauncherFileController: FileController {
    var parent: LaunchInstanceBridge
    
    var file: URL?
    
    func getFile() {
        print("y")
    }
    
    func setFile() {
        print("y")
    }
}

struct AppLauncherOpener: Opener {
    var parent: LaunchInstanceBridge
    
    func openApp() {
        let app = parent.appController.app!
        
        if let file = parent.fileController.file
        {
            let config = NSWorkspace.OpenConfiguration()
                config.activates = true
            
            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
                print(app as Any)
            }
        }
        else
        {
            let openConfig = NSWorkspace.OpenConfiguration()
            openConfig.activates = true
            
            NSWorkspace.shared.openApplication(at: app, configuration: openConfig, completionHandler: { _, _ in
                print("OPENED APP")
            })
        }
    }
}

struct AppLauncherPanel: Panel {
    var parent: LaunchInstanceBridge
    
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
        
        return panel
    }
    
    func openPanel(with panel: NSOpenPanel) -> Bool {
        if panel.runModal() == .OK
        {
            return panel.url?.pathExtension == "app"
        }
        
        return false
    }
}

// ------------------------
// FileLauncher
// ------------------------

struct FileLauncherAppController: AppController {
    var parent: LaunchInstanceBridge
    
    var app: URL?
    
    func getApp() -> URL? {
        if let app = app
        {
            return app
        }
        
        return getDefaultApp()
    }
    
    func setApp() {
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
    var parent: LaunchInstanceBridge
    
    var file: URL?
    
    func getFile() {
        print("y")
    }
    
    func setFile() {
        print("y")
    }
}

struct FileLauncherOpener: Opener {
    var parent: LaunchInstanceBridge
    
    func openApp() {
        guard let app = parent.appController.getApp() else {
            print("ERROR 194324")
            return
        }
        
        let file = parent.fileController.file!
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
        
        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
            print(file)
        }
    }
}

struct FileLauncherPanel: Panel {
    var parent: LaunchInstanceBridge
    
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
        
        return panel
    }
    
    func openPanel(with panel: NSOpenPanel) -> Bool {
        if panel.runModal() == .OK
        {
            return panel.url?.pathExtension != "app"
        }
        
        return false
    }
}

// ------------------------
// FolderLauncher
// ------------------------
struct FolderLauncherPanel: Panel {
    var parent: LaunchInstanceBridge
    
    func createPanel() -> NSOpenPanel {
        let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
        
        return panel
    }
}

// ------------------------
// EmptyLauncher
// ------------------------

struct EmptyLauncherAppController: AppController {
    var parent: LaunchInstanceBridge
    
    var app: URL?
    
    func getApp() -> URL? {
        return getDefaultApp()
    }
    
    func setApp() {
        print("x")
    }
    
    func iconForApp(size: Int) -> NSImage {
        guard let image = NSImage(systemSymbolName: "questionmark.square.fill", accessibilityDescription: nil) else { fatalError("Failed to get icon") }
        
        image.size = NSSize(width: size, height: size)
        
        return image
    }
}

struct EmptyLauncherFileController: FileController {
    var parent: LaunchInstanceBridge
    
    var file: URL?
    
    func getFile() {
        print("y")
    }
    
    func setFile() {
        print("y")
    }
}

struct EmptyLauncherOpener: Opener {
    var parent: LaunchInstanceBridge
    
    func openApp() {
        print("You can't open this...")
    }
}

struct EmptyLauncherPanel: Panel {
    var parent: LaunchInstanceBridge
    
    func createPanel() -> NSOpenPanel {
        fatalError("This doesn't work...")
    }
}

// ------------------------
// Website Launcher
// ------------------------

struct WebsiteLauncherAppController: AppController {
    var parent: LaunchInstanceBridge
    
    var app: URL?
    
    func getApp() -> URL? {
        if let app = app
        {
            return app
        }
        
        return getDefaultApp()
    }
    
    func setApp() {
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

struct WebsiteLauncherFileController: FileController {
    var parent: LaunchInstanceBridge
    
    var file: URL?
    
    func getFile() {
        print("y")
    }
    
    func setFile() {
        print("y")
    }
}

struct WebsiteLauncherOpener: Opener {
    var parent: LaunchInstanceBridge
    
    func openApp() {
        guard let app = parent.appController.getApp(),
              let file = parent.fileController.file
        else
        {
            return
        }
        
        let config = NSWorkspace.OpenConfiguration()
            config.activates = true
        
        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
            print(app as Any)
        }
    }
}

struct WebsiteLauncherPanel: Panel {
    var parent: LaunchInstanceBridge
    
    func createPanel() -> NSOpenPanel {
        fatalError("Yeah.. no")
    }
    
    func openPanel(with panel: NSOpenPanel) -> Bool {
        fatalError("Yeah.. no again")
    }
}

//
////
////  LauncherModel.swift
////  TapIn
////
////  Created by Fredrik Skjelvik on 20/06/2021.
////
//
//import SwiftUI
//
//// ------------------------
//// GENERAL PURPOSE
//// ------------------------
//
//enum LauncherType: String {
//    case app = "App"
//    case file = "File"
//    case folder = "Folder"
//    case website = "Website"
//    case terminal = "Terminal"
//}
//
//protocol AppController {
//    var parent: LaunchInstanceBridge { get set }
//
//    var app: URL? { get set }
//
//    func getApp() -> URL?
//    func setApp()
//
//    func iconForApp(size: Int) -> NSImage
//}
//
//extension AppController {
//    init(parent: LaunchInstanceBridge, app: URL?) {
//        self.parent = parent
//        self.app = app
//    }
//}
//
//protocol FileController {
//    var parent: LaunchInstanceBridge { get set }
//
//    var file: URL? { get set }
//
//    func getFile()
//    func setFile()
//}
//
//extension FileController {
//    init(parent: LaunchInstanceBridge, file: URL?) {
//        self.parent = parent
//        self.file = file
//    }
//}
//
//protocol Opener {
//    var parent: LaunchInstanceBridge { get set }
//
//    func openApp()
//}
//
//extension Opener {
//    init(parent: LaunchInstanceBridge) {
//        self.parent = parent
//    }
//}
//
//protocol Panel {
//    var parent: LaunchInstanceBridge { get set }
//
//    func openPanel() -> NSOpenPanel
//}
//
//extension Panel {
//    init(parent: LaunchInstanceBridge) {
//        self.parent = parent
//    }
//}
//
//class LaunchInstanceBridge {
//    init(name: String, type: LauncherType) {
//        self.name = name
//        self.type = type
//    }
//
//    func initializeBridge(appController: AppController, fileController: FileController, opener: Opener) {
//        self.appController = appController
//        self.fileController = fileController
//        self.opener = opener
//    }
//
//    var name: String
//    var type: LauncherType
//    var fileController: FileController
//    var appController: AppController
//    var opener: Opener
//    var panel: Panel
//
//    func instructionText() -> String {
//        switch type {
//            case .app:
//                return "Drop an app here"
//            case .file:
//                return "Drop a file here"
//            case .folder:
//                return "Drop a folder here"
//            case .website:
//                return "Drag a website here or type in a link below"
//            case .terminal:
//                return "Drag a folder here"
//        }
//    }
//}
//
//// ------------------------
//// AppLauncher
//// ------------------------
//struct AppLauncherAppController: AppController {
//    var parent: LaunchInstanceBridge
//
//    var app: URL?
//
//    func getApp() -> URL? {
//        print("x")
//        return nil
//    }
//
//    func setApp() {
//        print("x")
//    }
//
//    func iconForApp(size: Int) -> NSImage {
//        let image = NSWorkspace.shared.icon(forFile: app!.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//}
//
//struct AppLauncherFileController: FileController {
//    var parent: LaunchInstanceBridge
//
//    var file: URL?
//
//    func getFile() {
//        print("y")
//    }
//
//    func setFile() {
//        print("y")
//    }
//}
//
//struct AppLauncherOpener: Opener {
//    var parent: LaunchInstanceBridge
//
//    func openApp() {
//        let app = parent.appController.app!
//
//        if let file = parent.fileController.file
//        {
//            let config = NSWorkspace.OpenConfiguration()
//                config.activates = true
//
//            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
//                print(app as Any)
//            }
//        }
//        else
//        {
//            NSWorkspace.shared.open(app)
//        }
//    }
//}
//
//struct AppLauncherPanel: Panel {
//    var parent: LaunchInstanceBridge
//
//    func openPanel() -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.allowsMultipleSelection = false
//            panel.canChooseDirectories = false
//            panel.canChooseFiles = true
//
//        return panel
//    }
//}
//
//let appLauncher = LaunchInstanceBridge(
//    name: "Spotify",
//    type: .app
//)
//
//appLauncher.initializeBridge(
//    appController: AppLauncherAppController(parent: appLauncher, app: URL(fileURLWithPath: "/Applications/Spotify.app")),
//    fileController: AppLauncherFileController(parent: appLauncher, file: nil),
//    opener: AppLauncherOpener(parent: appLauncher)
//)
//
//// ------------------------
//// FileLauncher
//// ------------------------
//
//struct FileLauncherAppController: AppController {
//    var parent: LaunchInstanceBridge
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
//    private func getDefaultApp() -> URL? {
//        let file = parent.fileController.file!
//
//        return NSWorkspace.shared.urlForApplication(toOpen: file)
//    }
//
//    func setApp() {
//        print("x")
//    }
//
//    func iconForApp(size: Int) -> NSImage {
//        let image = NSWorkspace.shared.icon(forFile: app!.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//}
//
//struct FileLauncherFileController: FileController {
//    var parent: LaunchInstanceBridge
//
//    var file: URL?
//
//    func getFile() {
//        print("y")
//    }
//
//    func setFile() {
//        print("y")
//    }
//
//    private func getCompatibleApps() -> [URL] {
//        guard let cfURL = file as CFURL? else { fatalError("Error 19442") }
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
//struct FileLauncherOpener: Opener {
//    var parent: LaunchInstanceBridge
//
//    func openApp() {
//        guard let app = parent.appController.getApp() else {
//            print("ERROR 194324")
//            return
//        }
//
//        let file = parent.fileController.file!
//
//        let config = NSWorkspace.OpenConfiguration()
//            config.activates = true
//
//        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
//            print(file)
//        }
//    }
//}
//
//struct FileLauncherPanel: Panel {
//    var parent: LaunchInstanceBridge
//
//    func openPanel() -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.canChooseDirectories = false
//            panel.canChooseFiles = true
//
//        return panel
//    }
//}
//
//let fileLauncher = LaunchInstanceBridge(
//    name: "Screenshot",
//    type: .file
//)
//
//fileLauncher.initializeBridge(
//    appController: AppLauncherAppController(parent: fileLauncher, app: URL(fileURLWithPath: "/Applications/Preview.app")),
//    fileController: AppLauncherFileController(parent: fileLauncher, file: URL(fileURLWithPath: "/Users/fredrik/Desktop/Screenshot.png")),
//    opener: AppLauncherOpener(parent: fileLauncher)
//)
//
//// ------------------------
//// EmptyLauncher
//// ------------------------
//let emptyLauncher = LaunchInstanceBridge(
//    name: "New App",
//    type: .app
//)
//
//emptyLauncher.initializeBridge(
//    appController: AppLauncherAppController(parent: emptyLauncher, app: nil),
//    fileController: AppLauncherFileController(parent: emptyLauncher, file: nil),
//    opener: AppLauncherOpener(parent: emptyLauncher)
//)
//
////protocol LaunchInstance {
////    var name: String { get set }
////
////    func mainIcon(size: Int) -> NSImage
////    func launch()
////}
////
////extension LaunchInstance {
////    static func iconForApp(app url: URL, size: Int) -> NSImage {
////        let image = NSWorkspace.shared.icon(forFile: url.path)
////            image.size = NSSize(width: size, height: size)
////
////        return image
////    }
////
////    static func panelForLauncherType(type: LauncherType) -> NSOpenPanel {
////        let panel = NSOpenPanel()
////            panel.allowsMultipleSelection = false
////
////        if type == .website {
////            fatalError("Can't get panel for website type")
////        }
////
////        switch type {
////            case .app:
////                panel.canChooseDirectories = false
////                panel.canChooseFiles = true
////                panel.allowedFileTypes = ["app"]
////            case .file:
////                panel.canChooseDirectories = false
////                panel.canChooseFiles = true
////            case .folder:
////                panel.canChooseDirectories = true
////                panel.canChooseFiles = false
////            default:
////                panel.canChooseFiles = true
////                panel.canChooseDirectories = true
////        }
////
////        return panel
////    }
////}
//
//
//// ...
//
//
//struct LauncherModel {
//    var instances: [LaunchInstance] = []
//
//    init() {
//        let craftURL = URL(fileURLWithPath: "/Applications/Craft.app")
//        let spotifyURL = URL(fileURLWithPath: "/Applications/Spotify.app")
//        let screenshotURL = URL(fileURLWithPath: "/Users/fredrik/Desktop/Screenshot.png")
//
//        createAppLaunchInstance(name: "Craft", app: craftURL, file: nil)
//        createAppLaunchInstance(name: "Spotify", app: spotifyURL, file: nil)
//        createFileLaunchInstance(name: "Screenshot", file: screenshotURL, app: nil)
//    }
//
//    mutating func createEmptyLaunchInstance(type: LauncherType) {
//        let instance = EmptyInstance(type: type)
//        instances.append(instance)
//    }
//
//    mutating func createAppLaunchInstance(name: String, app: URL, file: URL?) {
//        let instance = AppLauncher(name: name, app: app, file: file)
//        instances.append(instance)
//    }
//
//    mutating func createFileLaunchInstance(name: String, file: URL, app: URL?) {
//        let instance = FileLauncher(name: name, file: file, app: app)
//        instances.append(instance)
//    }
//}
//
//struct IdentifiableLaunchInstance: Identifiable {
//    var id = UUID()
//    var launchInstance: LaunchInstance
//}
//
//// - Add, remove, rename instance
//// - Add file, app, terminal, folder, etc.
////  - have check type method
//// -
//
//protocol LaunchInstance {
//    var name: String { get set }
//
//    func mainIcon(size: Int) -> NSImage
//    func launch()
//}
//
//extension LaunchInstance {
//    static func iconForApp(app url: URL, size: Int) -> NSImage {
//        let image = NSWorkspace.shared.icon(forFile: url.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    static func panelForLauncherType(type: LauncherType) -> NSOpenPanel {
//        let panel = NSOpenPanel()
//            panel.allowsMultipleSelection = false
//
//        if type == .website {
//            fatalError("Can't get panel for website type")
//        }
//
//        switch type {
//            case .app:
//                panel.canChooseDirectories = false
//                panel.canChooseFiles = true
//                panel.allowedFileTypes = ["app"]
//            case .file:
//                panel.canChooseDirectories = false
//                panel.canChooseFiles = true
//            case .folder:
//                panel.canChooseDirectories = true
//                panel.canChooseFiles = false
//            default:
//                panel.canChooseFiles = true
//                panel.canChooseDirectories = true
//        }
//
//        return panel
//    }
//}
//
//struct EmptyInstance: LaunchInstance {
//    var type: LauncherType
//    var name: String
//
//    init(type: LauncherType) {
//        self.type = type
//        self.name = type.rawValue
//    }
//
//    func instructionText() -> String {
//        switch type {
//            case .app:
//                return "Drop an app here"
//            case .file:
//                return "Drop a file here"
//            case .folder:
//                return "Drop a folder here"
//            case .website:
//                return "Drag a website here or type in a link below"
//        }
//    }
//
//    func mainIcon(size: Int) -> NSImage {
//        let image = NSImage(systemSymbolName: "questionmark.diamond.fill", accessibilityDescription: nil)!
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    func launch() {
//        print("Can't launch")
//    }
//}
//
//struct AppLauncher: LaunchInstance {
//    var name: String
//    var app: URL
//    var file: URL?
//
//    init(name: String, app: URL, file: URL?) {
//        self.name = name
//        self.app = app
//        self.file = file
//    }
//
//    func mainIcon(size: Int) -> NSImage {
//        let image = NSWorkspace.shared.icon(forFile: app.path)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    func launch() {
//        if let file = file
//        {
//            let config = NSWorkspace.OpenConfiguration()
//                config.activates = true
//
//            NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
//                print(app as Any)
//            }
//        }
//        else
//        {
//            NSWorkspace.shared.open(app)
//        }
//    }
//
//    static func applicationName(url: URL) -> String {
//        return FileManager.default.displayName(atPath: url.path)
//    }
//}
//
//struct FileLauncher: LaunchInstance {
//    var name: String
//    var file: URL
//    var app: URL?
//
//    init(name: String, file: URL, app: URL?) {
//        self.name = name
//        self.file = file
//        self.app = app
//    }
//
//    func getApp() -> URL {
//        if let app = app
//        {
//            return app
//        }
//
//        if let defaultApp = NSWorkspace.shared.urlForApplication(toOpen: file)
//        {
//            return defaultApp
//        }
//        else
//        {
//            fatalError("No set app nor default app found to open file \(file.path)")
//        }
//    }
//
//    mutating func setApp(_ url: URL) {
//        app = url
//    }
//
//    func mainIcon(size: Int) -> NSImage {
//        let iconForPath = app == nil ? file.path : app!.path
//
//        let image = NSWorkspace.shared.icon(forFile: iconForPath)
//            image.size = NSSize(width: size, height: size)
//
//        return image
//    }
//
//    func launch() {
//        let app = getApp()
//
//        let config = NSWorkspace.OpenConfiguration()
//            config.activates = true
//
//        NSWorkspace.shared.open([file], withApplicationAt: app, configuration: config) { (app, error) in
//            print(self.file)
//        }
//    }
//
//    func getCompatibleApps() -> [URL] {
//        let cfURL = file as CFURL
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
