import SwiftUI

struct FileSystemInstanceLauncherView: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    @State var instance: any FileSystemBasedBehavior & BaseLauncherInstanceBehavior
    
    @State private var hideOnLaunch = false
    
    var body: some View {
        TappableAppIconView(instance: instance, onSubmitFile: { url in
            print(url.absoluteURL)
        })
        
        if let openableInstance = instance as? Openable {
            Button("Open") {
                openableInstance.open()
            }
        }
        
        if instance.object.instantiated
        {
            Toggle("Hide app on launch", isOn: $hideOnLaunch)
                .toggleStyle(.checkbox)
        }
    }
    
}

//struct AppLauncherView: View {
//    var body: some View {
//        VStack {
//            TappableAppIconView(launcherInstance: launcherInstance)
//
//            EditableLauncherNameView(launcherInstance: launcherInstance)
//
//
//            Toggle("Hide app on launch", isOn: $hideOnLaunch)
//                .toggleStyle(.checkbox)
//                .onChange(of: hideOnLaunch) { value in
//                    workspace.launcher.toggleHideOnLaunch(instance: launcherInstance, value: value)
//                }
//        }.onAppear(perform: {
//            hideOnLaunch = launcherInstance.hideOnLaunch
//        })
//    }
//}
