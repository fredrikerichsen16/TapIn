//
//  FileLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 15/08/2021.
//

import SwiftUI
import RealmSwift

struct FileLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    @Environment(\.realm) var realm

    @State private var openWithSelection: Int = 0
    
    var body: some View {
        VStack {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = launcherInstance.panel.createPanel()

                    if launcherInstance.panel.openPanel(with: panel), let url = panel.url {
                        let name = applicationReadableName(url: url)
                        
                        if let thawed = launcherInstance.thaw() {
                            try! realm.write {
                                thawed.name = name
                                thawed.filePath = url.path
                            }
                        }
                    }
                }

            Text(launcherInstance.name).font(.title2)

            if let compatibleApps = launcherInstance.fileController.getCompatibleApps() {
                openWithMenu(compatibleApps)
            }

            Button("Open") {
                launcherInstance.opener.openApp()
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
                        Text(index == 0 ? "Default" : app.fileName)
                    }.tag(index)
                }
            }
            .pickerStyle(PopUpButtonPickerStyle())
            .onChange(of: openWithSelection) { appIndex in
                let url = compatibleApps[appIndex]

                if let thawed = launcherInstance.thaw() {
                    try! realm.write {
                        thawed.appPath = url.path
                    }
                }

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
