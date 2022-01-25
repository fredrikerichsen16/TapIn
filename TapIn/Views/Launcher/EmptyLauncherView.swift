//
//  EmptyLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import SwiftUI

struct EmptyLauncherView: View {
    @ObservedObject var workspace: Workspace
    
    var instance: LaunchInstanceBridge? {
        return workspace.launcher.activeInstance
    }
    
    var activeInstance: Int? {
        return workspace.launcher.selected
    }
    
    var body: some View {
        VStack {
            if let instance = instance, let activeInstance = activeInstance
            {
                Image(nsImage: instance.appController.iconForApp(size: 128))
                    .font(.system(size: 80))
                    .onTapGesture {
                        let panel = instance.panel.createPanel()
                        
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
                                    let index = activeInstance
                                    
                                    workspace.launcher.instances.insert(launcher, at: index)
                                    workspace.launcher.instances.remove(at: index + 1)
                                    
                                    workspace.launcher.selected = nil
                                }
                            }
                        }
                    }
                    
                Text(instance.name + " - Empty").font(.title2)
            }
            else
            {
                Text("Failure 3")
            }
        }
    }
}
