//
//  EmptyLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import SwiftUI
import RealmSwift

struct EmptyLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    @Environment(\.realm) var realm
    
    var body: some View {
        VStack {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = launcherInstance.panel.createPanel()
                    
                    if panel.runModal() == .OK
                    {
                        if let url = panel.url
                        {
                            let name = applicationReadableName(url: url)
                            
                            let launcherApp: URL?
                            let launcherFile: URL?
                            
                            if launcherInstance.fullType == .empty(.app)
                            {
                                launcherApp = url
                                launcherFile = nil
                            }
                            else
                            {
                                launcherApp = nil
                                launcherFile = url
                            }
                            
                            if let thawed = launcherInstance.thaw() {
                                try! realm.write {
                                    thawed.name = name
                                    thawed.appPath = launcherApp?.path
                                    thawed.filePath = launcherFile?.path
                                    thawed.instantiated = true
                                }
                            }
                        }
                    }
                }
                
            Text(launcherInstance.name + " - Empty").font(.title2)
        }
    }
}
