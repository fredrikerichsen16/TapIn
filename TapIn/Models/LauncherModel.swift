//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

class LauncherModel: ObservableObject {
    @Published var instances: [LaunchInstanceBridge] = []
    @Published var selected: Int? = 0
    
    init() {
        instances = [
            LaunchInstanceBridge.createAppLauncher(name: "Spotify", app: URL(fileURLWithPath: "/Applications/Spotify.app"), file: nil),
            LaunchInstanceBridge.createFileLauncher(name: "Screenshot", file: URL(fileURLWithPath: "/Users/fredrik/Desktop/meme.png"), app: nil),
            LaunchInstanceBridge.createWebsiteLauncher(name: "Facebook", file: URL(string: "http://www.youtube.com")!, app: nil),
            LaunchInstanceBridge.createEmptyLauncher(type: .app)
        ]
        
        selected = 0
    }
    
    var activeInstance: LaunchInstanceBridge? {
        guard let _selected = selected else { return nil }
        
        return instances[safe: _selected]
    }

    func addInstance(instance: LaunchInstanceBridge) {
        self.instances.append(instance)
    }
    
}
