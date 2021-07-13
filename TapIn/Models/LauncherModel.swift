//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

struct LauncherModel {
    var instances: [LaunchInstance] = []
    
    func createLaunchInstance(name: String, app: URL, appFirst: Bool, file: URL?) {
        let instance = LaunchInstance(name: name, app: app, file: file, appFirst: appFirst)
        instances.append(instance)
    }
}

struct LaunchInstance {
    var name: String
    var app: URL
    var file: URL?
    var appFirst: Bool = true
    
    init(name: String, appFirst: Bool, app: URL?, file: URL?) {
        self.name = name
        self.appFirst = appFirst
        self.file = file
        
        if app != nil
        {
            self.app = app
        }
        else
        {
            self.app = self.getDefaultApp()
        }
    }
    
    func getIcon(for url: URL, size: Int = 80) -> NSImage {
        let image = NSImage = NSWorkspace.shared.icon(for: url.path)
            image.size = NSSize(width: size, height: size)
        
        return image
    }
    
    func getDefaultApp() -> URL {
        let compatible = self.getCompatibleApps()
        return compatible[0]
    }
    
    func getCompatibleApps() -> [URL] {
        let cfUrl = file as CFURL

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
            
            NSWorkspace.shared.open([file!], withApplicationAt: app, configuration: config) { (app, error) in
                print(app)
            }
        }
        else
        {
            NSWorkspace.shared.open(app)
        }
    }
}
