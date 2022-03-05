//
//  FileLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 15/08/2021.
//

//import SwiftUI
//
//struct FileLauncherView: View {
//    @ObservedObject var workspace: Workspace
//
//    @State private var openWithSelection: Int = 0
//
//    var instance: LaunchInstanceBridge? {
//        workspace.launcher.activeInstance
//    }
//
//    var activeInstance: Int? {
//        workspace.launcher.selected
//    }
//
//    var body: some View {
//        VStack {
//            if let instance = instance, let activeInstance = activeInstance
//            {
//                Image(nsImage: instance.appController.iconForApp(size: 128))
//                    .font(.system(size: 80))
//                    .onTapGesture {
//                        let panel = instance.panel.createPanel()
//
//                        if instance.panel.openPanel(with: panel), let url = panel.url {
//                            let name = applicationReadableName(url: url)
//                            let launcher: LaunchInstanceBridge
//
//                            if instance.type == .folder {
//                                launcher = LaunchInstanceBridge.createFolderLauncher(name: name, file: url, app: nil)
//                            } else {
//                                launcher = LaunchInstanceBridge.createFileLauncher(name: name, file: url, app: nil)
//                            }
//
//                            let index = activeInstance
//
//                            workspace.launcher.instances.insert(launcher, at: index)
//                            workspace.launcher.instances.remove(at: index + 1)
//
//                            workspace.launcher.selected = nil
//                        }
//                    }
//
//                Text(instance.name).font(.title2)
//
//                if let compatibleApps = instance.fileController.getCompatibleApps() {
//                    openWithMenu(compatibleApps)
//                }
//
//                Button("Open") {
//                    instance.opener.openApp()
//                }
//            }
//            else
//            {
//                Text("Failure")
//            }
//        }
//    }
//
//    @ViewBuilder
//    func openWithMenu(_ compatibleApps: [URL]) -> some View {
//        VStack {
//            if let instance = instance//, let activeInstance = activeInstance
//            {
//                Text("Open file with app...")
//                Picker("", selection: $openWithSelection) {
//                    ForEach(Array(zip(compatibleApps.indices, compatibleApps)), id: \.0) { index, app in
//                        HStack {
//                            Image(nsImage: getAppIcon(for: app, size: 16))
//                            Text(index == 0 ? "Default" : app.fileName)
//                        }.tag(index)
//                    }
//                }
//                .pickerStyle(PopUpButtonPickerStyle())
//                .onChange(of: openWithSelection) { appIndex in
//                    let url = compatibleApps[appIndex]
//
//                    instance.appController.app = url
//
//                    print("""
//                        - Path: \(url.path)
//                        - Is directory?: \(url.hasDirectoryPath)
//                        - Is file?: \(url.isFileURL)
//                        - Scheme: \(String(describing: url.scheme))
//                        - Last Path Component: \(url.lastPathComponent)
//                        - Last Path Component: \(url.fileName)
//                        - Extension: \(url.pathExtension)
//                        - File exitsts?: \(FileManager.default.fileExists(atPath: url.path))
//                        - urlForApp: \(String(describing: NSWorkspace.shared.urlForApplication(toOpen: url)))
//                    """)
//                }
//            }
//        }
//    }
//}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
