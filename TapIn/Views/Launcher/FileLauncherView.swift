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
    
    var instance: FileLauncher {
        if let instance = workspace.launcher.instances[safe: instanceIndex] as? FileLauncher {
            return instance
        } else {
            fatalError("Can't get FileLauncher instance")
        }
    }
    
    var body: some View {
        VStack {
            Image(nsImage: instance.mainIcon(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = AppLauncher.panelForLauncherType(type: .file)
                    
                    if panel.runModal() == .OK {
                        if let url = panel.url {
                            print(url)
                        }
                    }
                }
            
            Text(instance.name).font(.title2)
            
            let compatibleApps = instance.getCompatibleApps()
            
            openWithMenu(compatibleApps)
        }
    }
    
    @ViewBuilder
    func openWithMenu(_ compatibleApps: [URL]) -> some View {
        VStack {
            Text("Open file with app...")
            Picker("", selection: $openWithSelection) {
                ForEach(Array(zip(compatibleApps.indices, compatibleApps)), id: \.0) { index, app in
                    HStack {
                        Image(nsImage: FileLauncher.iconForApp(app: app, size: 16))
                        Text(app.lastPathComponent)
                    }.tag(index)
                }
            }
            .pickerStyle(PopUpButtonPickerStyle())
            .onChange(of: openWithSelection) { appIndex in
                let url = compatibleApps[appIndex]
                
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
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
