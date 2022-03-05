import SwiftUI
import RealmSwift

//struct LauncherView<Content>: View where Content: View {
//    @ObservedObject var workspace: Workspace
//    private let content: Content
//
//    init(@ViewBuilder content: () -> Content) {
//        self.content = content()
//    }
//
//    var body: some View {
//        content
//    }
//}

struct AppLauncherView: View {
    @ObservedRealmObject var launcherInstance: LauncherInstanceDB
    
    var launcherBridge: LaunchInstanceBridge {
        launcherInstance.launcherBridge!
    }
    
//    var instance: LaunchInstanceBridge? {
//        return workspace.launcher.activeInstance
//    }
//
//    var activeInstance: Int? {
//        return workspace.launcher.selected
//    }
    
    var body: some View {
        VStack {
            Image(nsImage: launcherBridge.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = launcherBridge.panel.createPanel()
                    
                    if launcherBridge.panel.openPanel(with: panel), let url = panel.url
                    {
                        let name = applicationReadableName(url: url)

                        let appLauncher = LaunchInstanceBridge.createAppLauncher(name: name, app: url, file: nil)
                        
                        print(appLauncher.name)
                        print(appLauncher.type)
                        
//                        launcherInstance.launcher.first!.replaceInstance(launcherInstance, appLauncher)
                    }
                }
                
            Text(launcherBridge.name).font(.title2)
            
            Button("Open") {
                launcherBridge.opener.openApp()
            }
        }
    }
}

//struct AppLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLauncher()
//    }
//}
