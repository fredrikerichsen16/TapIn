//
//  LauncherModel.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 20/06/2021.
//

import SwiftUI

class LauncherModel: ObservableObject {
    var instances: [LaunchInstanceBridge] = []
    
    init() {
        instances = [
            LaunchInstanceBridge.createAppLauncher(name: "Spotify", app: URL(fileURLWithPath: "/Applications/Spotify.app"), file: nil),
            LaunchInstanceBridge.createFileLauncher(name: "Screenshot", file: URL(fileURLWithPath: "/Users/fredrik/Desktop/meme.png"), app: nil),
            LaunchInstanceBridge.createEmptyLauncher(type: .app)
        ]
    }

    func addInstance(instance: LaunchInstanceBridge) {
        self.instances.append(instance)
    }
}
