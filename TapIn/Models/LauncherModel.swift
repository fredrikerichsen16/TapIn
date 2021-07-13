//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

struct LauncherModel {
    init() {
        createLaunchInstance(
            name: "Craft",
            appFirst: true,
            app: URL(fileURLWithPath: "/Applications/Craft.app"),
            file: nil
        )

        createLaunchInstance(
            name: "Spotify",
            appFirst: true,
            app: URL(fileURLWithPath: "/Applications/Spotify.app"),
            file: nil
        )
    }
    
    var selected: Int?
    var instances: [LaunchInstance] = []
    
    mutating func createLaunchInstance(name: String, appFirst: Bool, app: URL?, file: URL?) {
        let instance = LaunchInstance(name: name, appFirst: appFirst, app: app, file: file)
        instances.append(instance)
    }
}

struct LaunchInstance: Identifiable {
    var id = UUID()
    var name: String
    var app: URL?
    var file: URL?
    var appFirst: Bool = true
    
    func getApp() -> URL {
        if let _app = app
        {
            return _app
        }
        else
        {
            return getDefaultApp()
        }
    }
    
    init(name: String, appFirst: Bool, app: URL?, file: URL?) {
        self.name = name
        self.appFirst = appFirst
        self.app = app
        self.file = file
    }
    
    static func getIcon(for url: URL, size: Int = 80) -> NSImage {
        let image: NSImage = NSWorkspace.shared.icon(forFile: url.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func getDefaultApp() -> URL {
        if file != nil, let defaultApp = NSWorkspace.shared.urlForApplication(toOpen: file!)
        {
            return defaultApp
        }
        else
        {
            return URL(fileURLWithPath: "/Applications/Notes.app")
        }
    }
    
    func getCompatibleApps() -> [URL] {
        guard file != nil else { fatalError("File is not defined") }
        
        let cfUrl = file! as CFURL

        var URLs: [URL] = []

        if let appURLs = LSCopyApplicationURLsForURL(cfUrl, .all)?.takeRetainedValue()
        {
            for url in appURLs as! [URL] {
                URLs.append(url)
            }
        }

        return URLs
    }
    
    func open() {
        if file != nil
        {
            let config = NSWorkspace.OpenConfiguration()
                config.activates = true
            
            NSWorkspace.shared.open([file!], withApplicationAt: getApp(), configuration: config) { (app, error) in
                print(app)
            }
        }
        else
        {
            NSWorkspace.shared.open(getApp())
        }
    }
    
    func urlInfo(for url: URL) {
        print("""
            - Path: \(url.path)
            - Is directory?: \(url.hasDirectoryPath)
            - Is file?: \(url.isFileURL)
            - Scheme: \(url.scheme)
            - Last Path Component: \(url.lastPathComponent)
            - Extension: \(url.pathExtension)
            - File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
            - urlForApp: \(NSWorkspace.shared.urlForApplication(toOpen: url))
        """)
    }
}
