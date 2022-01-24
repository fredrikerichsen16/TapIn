import SwiftUI

struct AppLauncherView: View {
    @ObservedObject var workspace: Workspace
    @State var instanceIndex: Int
    
    var instance: LaunchInstanceBridge {
        if let instance = workspace.launcher.instances[safe: instanceIndex] {
            return instance
        } else {
            fatalError("Can't get AppLauncher instance")
        }
    }
    
    var body: some View {
        VStack {
            Image(nsImage: instance.appController.iconForApp(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = instance.panel.openPanel()
                    
                    if panel.runModal() == .OK
                    {
                        if let url = panel.url
                        {
                            let name = applicationReadableName(url: url)

                            let appLauncher = LaunchInstanceBridge.createAppLauncher(name: name, app: url, file: nil)

                            workspace.launcher.instances.insert(appLauncher, at: instanceIndex)
                            workspace.launcher.instances.remove(at: instanceIndex + 1)
                        }
                    }
                }
                
            Text(instance.name).font(.title2)
            
            Button("Open") {
                instance.opener.openApp()
            }
        }
    }
}

//struct AppLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLauncher()
//    }
//}
