//import SwiftUI
//import RealmSwift
//
////struct LauncherView<Content>: View where Content: View {
////    @ObservedObject var workspace: Workspace
////    private let content: Content
////
////    init(@ViewBuilder content: () -> Content) {
////        self.content = content()
////    }
////
////    var body: some View {
////        content
////    }
////}
//
//struct AppLauncherView: View {
//    @EnvironmentObject var workspace: WorkspaceVM
//    var launcherInstance: LauncherInstanceDB
//    
//    @State private var hideOnLaunch: Bool = false
//    @State private var isEditingAppName: Bool = false
//    
//    var body: some View {
//        VStack {
//            TappableAppIconView(launcherInstance: launcherInstance)
//            
//            EditableLauncherNameView(launcherInstance: launcherInstance)
//            
//            Button("Open") {
//                launcherInstance.opener.openApp()
//            }
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
//
////struct AppLauncherView_Previews: PreviewProvider {
////    static var previews: some View {
////        AppLauncher()
////    }
////}
