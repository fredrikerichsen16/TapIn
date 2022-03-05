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
    @Environment(\.realm) var realm
    
    var body: some View {
        VStack {
            Image(nsImage: launcherInstance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = launcherInstance.panel.createPanel()
                    
                    if launcherInstance.panel.openPanel(with: panel), let url = panel.url
                    {
                        let name = applicationReadableName(url: url)
                        
                        if let thawed = launcherInstance.thaw() {
                            try! realm.write {
                                thawed.name = name
                                thawed.appPath = url.path
                                thawed.instantiated = true
                                
                                print("Thawed AppPath:")
                                print(thawed.appPath)
                            }
                        }
                    }
                }
                
            Text(launcherInstance.name).font(.title2)
            
            Button("Open") {
                launcherInstance.opener.openApp()
            }
        }
    }
}

//struct AppLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLauncher()
//    }
//}
