import SwiftUI

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
    @EnvironmentObject var workspace: Workspace
    
    var instance: LaunchInstanceBridge? {
        return workspace.launcher.activeInstance
    }
    
    var activeInstance: Int? {
        return workspace.launcher.selected
    }
    
    var body: some View {
        VStack {
            if let instance = instance, let activeInstance = activeInstance
            {
                Image(nsImage: instance.appController.iconForApp(size: 128))
                    .font(.system(size: 80))
                    .onTapGesture {
                        let panel = instance.panel.createPanel()
                        
                        if instance.panel.openPanel(with: panel), let url = panel.url
                        {
                            let name = applicationReadableName(url: url)

                            let appLauncher = LaunchInstanceBridge.createAppLauncher(name: name, app: url, file: nil)
                            
                            let index = activeInstance
                            
                            workspace.launcher.instances.insert(appLauncher, at: index)
                            workspace.launcher.instances.remove(at: index + 1)
                            
                            workspace.launcher.selected = nil
                        }
                    }
                    
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

//struct AppLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLauncher()
//    }
//}
