//
//  FileLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 15/08/2021.
//

import SwiftUI

struct FileLauncherView: View {
    @ObservedObject var workspace: Workspace
    
    @State var instanceIndex: Int
    @State private var openWithSelection: Int = 0
    
    var instance: LaunchInstanceBridge {
        if let instance = workspace.launcher.instances[safe: instanceIndex] {
            return instance
        } else {
            fatalError("Can't get AppLauncher instance")
        }
    }
    
    var body: some View {
        VStack {
            Image(nsImage: instance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = instance.panel.openPanel()
                    
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            let name = applicationReadableName(url: url)
                            let launcher: LaunchInstanceBridge
                            
                            if instance.type == .folder {
                                launcher = LaunchInstanceBridge.createFolderLauncher(name: name, file: url, app: nil)
                            } else {
                                launcher = LaunchInstanceBridge.createFileLauncher(name: name, file: url, app: nil)
                            }
                            
                            workspace.launcher.instances.insert(launcher, at: instanceIndex)
                            workspace.launcher.instances.remove(at: instanceIndex + 1)
                            
//                            let name = applicationReadableName(url: url)
//                            let fileLauncher = LaunchInstanceBridge.createFileLauncher(name: name, file: url, app: nil)
                        }
                    }
                }
            
            Text(instance.name).font(.title2)
            
            let compatibleApps = instance.fileController.getCompatibleApps()
            
            openWithMenu(compatibleApps)
            
            Button("Open") {
                instance.opener.openApp()
            }
        }
    }
    
    @ViewBuilder
    func openWithMenu(_ compatibleApps: [URL]) -> some View {
        VStack {
            Text("Open file with app...")
            Picker("", selection: $openWithSelection) {
                ForEach(Array(zip(compatibleApps.indices, compatibleApps)), id: \.0) { index, app in
                    HStack {
                         Image(nsImage: getAppIcon(for: app, size: 16))
                        Text(app.fileName)
                    }.tag(index)
                }
            }
            .pickerStyle(PopUpButtonPickerStyle())
            .onChange(of: openWithSelection) { appIndex in
                let url = compatibleApps[appIndex]
                
                instance.appController.app = url
                
                print("""
                    - Path: \(url.path)
                    - Is directory?: \(url.hasDirectoryPath)
                    - Is file?: \(url.isFileURL)
                    - Scheme: \(String(describing: url.scheme))
                    - Last Path Component: \(url.lastPathComponent)
                    - Last Path Component: \(url.fileName)
                    - Extension: \(url.pathExtension)
                    - File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
                    - urlForApp: \(String(describing: NSWorkspace.shared.urlForApplication(toOpen: url)))
                """)
            }
        }
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
