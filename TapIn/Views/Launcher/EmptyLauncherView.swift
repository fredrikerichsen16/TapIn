//
//  EmptyLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import SwiftUI

struct EmptyLauncherView: View {
    @ObservedObject var workspace: Workspace
    @State var instanceIndex: Int
    
    var instance: LaunchInstanceBridge {
        if let instance = workspace.launcher.instances[safe: instanceIndex] {
            return instance
        } else {
            fatalError("Can't get EmptyLauncher instance")
        }
    }
    
    var body: some View {
        VStack {
            Image(nsImage: instance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = instance.panel.openPanel()
                    
                    if panel.runModal() == .OK
                    {
                        if let url = panel.url
                        {
                            let name = applicationReadableName(url: url)
                            
                            let launcherApp: URL?
                            let launcherFile: URL?
                            
                            if instance.type == .empty(.app)
                            {
                                launcherApp = url
                                launcherFile = nil
                            }
                            else
                            {
                                launcherApp = nil
                                launcherFile = url
                            }

                            if let launcher = LaunchInstanceBridge.createLauncherFromType(type: instance.type, name: name, app: launcherApp, file: launcherFile) {
                                workspace.launcher.instances.insert(launcher, at: instanceIndex)
                                workspace.launcher.instances.remove(at: instanceIndex + 1)
                            }
                        }
                    }
                }
                
            Text(instance.name + " - Empty").font(.title2)
        }
    }
}
