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
    @State private var hideOnLaunch: Bool = false
    
    @State private var isEditingAppName: Bool = false
    
    var body: some View {
        VStack {
            TappableAppIconView(launcherInstance: launcherInstance)
            
            if isEditingAppName
            {
                if #available(macOS 12.0, *)
                {
                    TextField("App Name", text: $launcherInstance.name)
                        .font(.body)
                        .frame(width: 120, alignment: .center)
                        .onSubmit {
                            isEditingAppName = false
                        }
                }
                else
                {
                    TextField("App Name", text: $launcherInstance.name, onCommit: {
                        isEditingAppName = false
                    })
                    .frame(width: 120, alignment: .center)
                    .font(.body)
                }
            }
            else
            {
                Text(launcherInstance.name).font(.title2)
                    .onTapGesture(count: 2) {
                        isEditingAppName = true
                    }
            }

            if let compatibleApps = launcherInstance.fileController.getCompatibleApps() {
                openWithMenu(compatibleApps)
            }

            Button("Open") {
                launcherInstance.opener.openApp()
            }
            
            Toggle("Hide app on launch", isOn: $hideOnLaunch)
                .toggleStyle(.checkbox)
                .onChange(of: hideOnLaunch) { value in
                    if let thawed = launcherInstance.thaw() {
                        try! realm.write {
                            thawed.hideOnLaunch = hideOnLaunch
                        }
                    }
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
            .frame(width: 200, alignment: .center)
            .pickerStyle(PopUpButtonPickerStyle())
            .onChange(of: openWithSelection) { appIndex in
                let url = compatibleApps[appIndex]

                if let thawed = launcherInstance.thaw() {
                    try! realm.write {
                        thawed.appUrl = url
                    }
                }
            }
        }
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
