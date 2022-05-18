// Components that are reused between AppLauncherView, FileLauncherView, EmptyLauncherView, WebsiteLauncherView

import SwiftUI
import RealmSwift

struct EditableLauncherNameView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        if isEditing
        {
            if #available(macOS 12.0, *)
            {
                TextField("App Name", text: $launcherInstance.name)
                    .font(.body)
                    .frame(width: 150, alignment: .center)
                    .onSubmit {
                        isEditing = false
                    }
            }
            else
            {
                TextField("App Name", text: $launcherInstance.name, onCommit: {
                    isEditing = false
                })
                .frame(width: 150, alignment: .center)
                .font(.body)
            }
        }
        else
        {
            Text(launcherInstance.name).font(.title2)
                .onTapGesture(count: 2) {
                    isEditing = true
                }
        }
    }
}

struct TappableAppIconView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    
    @State private var errorMessage: String = ""
    @State private var displayError: Bool = false
    
    @State private var hoveringOverAppIcon: Bool = false
    
    var body: some View {
        if #available(macOS 12.0, *) {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .onTapGesture {
                    let panel = launcherInstance.panel.createPanel()
                    let (url, completed) = launcherInstance.panel.openPanel(with: panel)
                    
                    if let url = url
                    {
                        let name = applicationReadableName(url: url)
                        
                        if launcherInstance.type == .file || launcherInstance.type == .folder
                        {
                            launcherInstance.fileController.setFile(name: name, filePath: url.path)
                        }
                        else if case .empty(_) = launcherInstance.fullType
                        {
                            if launcherInstance.fullType == .empty(.app)
                            {
                                launcherInstance.appController.setApp(name: name, appPath: url.path)
                            }
                            else
                            {
                                launcherInstance.fileController.setFile(name: name, filePath: url.path)
                            }
                        }
                        else
                        {
                            launcherInstance.appController.setApp(name: name, appPath: url.path)
                        }
                    }
                    else if completed == true
                    {
                        errorMessage = "You can only submit \(launcherInstance.type)s!"
                        displayError = true
                    }
                }
                .alert(errorMessage, isPresented: $displayError, actions: {})
                .overlay(ImageOverlay(), alignment: .center)
                .onHover(perform: { hovering in
                    hoveringOverAppIcon = hovering
                })
        } else {
            Text("Don't know how to handle < 12.0 versions yet")
        }
    }
          
    @ViewBuilder
    func ImageOverlay() -> some View {
        if hoveringOverAppIcon {
            ZStack {
                Image(systemName: "play.fill")
                    .frame(width: 100, height: 100, alignment: .center)
                    .background(Color.black)
                    .opacity(0.5)
                    .cornerRadius(10)
                    .font(.system(size: 24.0))
                    .foregroundColor(.white)
            }
        }
    }
}
