//
//  WebsiteLauncherView.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 24/01/2022.
//

import SwiftUI

struct WebsiteLauncherView: View {
    @ObservedObject var workspace: Workspace
    
    @State var websiteName: String = ""
    @State var websiteURL: String = ""
    @State private var showingSheet = false
    
    var instance: LaunchInstanceBridge? {
        workspace.launcher.activeInstance
    }
    
    var activeInstance: Int? {
        workspace.launcher.selected
    }
    
    var body: some View {
        VStack {
            if let instance = instance, let activeInstance = activeInstance
            {
                Image(nsImage: instance.appController.iconForApp(size: 128))
                    .font(.system(size: 80))
                    .onTapGesture {
                        showingSheet = true
                    }
                    .sheet(isPresented: $showingSheet, onDismiss: {
                        print("Dismissed")
                    }, content: {
                        if #available(macOS 12.0, *) {
                            HStack {
                                TextField("Website Name", text: $websiteName)
                                    .textFieldStyle(.squareBorder)
                                TextField("Website URL", text: $websiteURL)
                                    .textFieldStyle(.roundedBorder)
                            }
                        } else {
                            Text("Unavailable")
                        }
                        
                        Button("Submit") {
                            guard let url = URL(string: websiteURL)
                            else { return }
                            
                            let launcher = LaunchInstanceBridge.createWebsiteLauncher(name: websiteName, file: url, app: nil)
                            
                            let index = activeInstance
                            workspace.launcher.instances.insert(launcher, at: index)
                            workspace.launcher.instances.remove(at: index + 1)
                            
                            showingSheet = false
                            workspace.launcher.selected = nil
                        }
                    })
                
                Text(instance.name).font(.title2)
                
                Button("Open") {
                    instance.opener.openApp()
                }
            }
            else
            {
                Text("Failure")
            }
        }
    }
}

//struct FileLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        FileLauncherView()
//    }
//}
