// Components that are reused between AppLauncherView, FileLauncherView, EmptyLauncherView, WebsiteLauncherView

import SwiftUI
import RealmSwift

struct EditableLauncherNameView: View {
    @State var name: String
    var onSubmit: (_ name: String) -> Void
    
    @State private var isEditing: Bool = false
    
    var body: some View {
        if isEditing
        {
            TextField("", text: $name)
                .font(.body)
                .frame(width: 150, alignment: .center)
                .onSubmit {
                    isEditing = false
                    onSubmit(name)
                }
        }
        else
        {
            Text(name).font(.title2)
                .onTapGesture(count: 2) {
                    isEditing = true
                }
        }
    }
}

struct TappableAppIconView: View {
    @State var instance: any FileSystemBasedBehavior & BaseLauncherInstanceBehavior
    var onSubmitFile: (URL) -> Void
    
    @State private var hoveringOverAppIcon: Bool = false
    
    var body: some View {
        Image(nsImage: instance.getIcon(size: 128))
            .onTapGesture {
                let panel = instance.createPanel()
                let (url, completed) = instance.openPanel(with: panel)
                
                if let url = url, completed == true {
                    onSubmitFile(url)
                }
            }
            .overlay(ImageOverlay(), alignment: .center)
            .onHover(perform: { hovering in
                hoveringOverAppIcon = hovering
            })
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


//if let url = url
//{
//    let name = applicationReadableName(url: url)
//
//    if launcherInstance.type == .file || launcherInstance.type == .folder
//    {
//        launcherInstance.fileController.setFile(name: name, fileUrl: url)
//    }
//    else if case .empty(_) = launcherInstance.fullType
//    {
//        if launcherInstance.fullType == .empty(.app)
//        {
//            launcherInstance.appController.setApp(name: name, appUrl: url)
//        }
//        else
//        {
//            launcherInstance.fileController.setFile(name: name, fileUrl: url)
//        }
//    }
//    else
//    {
//        launcherInstance.appController.setApp(name: name, appUrl: url)
//    }
//}
//else if completed == true
//{
//    errorMessage = "You can only submit \(launcherInstance.type)s!"
//    displayError = true
//}
