//
//  EmptyLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 22/01/2022.
//

import SwiftUI
import RealmSwift

//struct EmptyLauncherView: View {
//    @ObservedRealmObject var launcher: LauncherDB
//    var instance: LaunchInstanceBridge
//    
//    var body: some View {
//        VStack {
//            Image(nsImage: instance.appController.iconForApp(size: 128))
//                .font(.system(size: 80))
//                .onTapGesture {
//                    let panel = instance.panel.createPanel()
//                    
//                    if panel.runModal() == .OK
//                    {
//                        if let url = panel.url
//                        {
//                            let name = applicationReadableName(url: url)
//                            
//                            let launcherApp: URL?
//                            let launcherFile: URL?
//                            
//                            if instance.type == .empty(.app)
//                            {
//                                launcherApp = url
//                                launcherFile = nil
//                            }
//                            else
//                            {
//                                launcherApp = nil
//                                launcherFile = url
//                            }
//
//                            if let launcher = LaunchInstanceBridge.createLauncherFromType(type: instance.type, name: name, app: launcherApp, file: launcherFile) {
//                                print("Launcher Name: \(launcher.name)")
//                                print("Turn it from empty to instantiated")
//                            }
//                        }
//                    }
//                }
//                
//            Text(instance.name + " - Empty").font(.title2)
//        }
//    }
//}
