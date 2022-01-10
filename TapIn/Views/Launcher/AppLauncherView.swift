import SwiftUI

struct AppLauncherView: View {
    @ObservedObject var workspace: Workspace
    @State var instanceIndex: Int
    
    var instance: AppLauncher {
        if let instance = workspace.launcher.instances[safe: instanceIndex] as? AppLauncher {
            return instance
        } else {
            fatalError("Can't get AppLauncher instance")
        }
    }
    
    var body: some View {
        VStack {
            Image(nsImage: instance.mainIcon(size: 128))
                .font(.system(size: 80))
                .onTapGesture {
                    let panel = AppLauncher.panelForLauncherType(type: .app)
                    
                    if panel.runModal() == .OK
                    {
                        if let url = panel.url
                        {
                            let name = AppLauncher.applicationName(url: url)
                            
                            let appLaunchInstance = AppLauncher(name: name, app: url, file: nil)
                            workspace.launcher.instances.insert(appLaunchInstance, at: instanceIndex)
                            workspace.launcher.instances.remove(at: instanceIndex + 1)
                        }
                    }
                }
                
            Text(instance.name).font(.title2)
        }
    }
}

//struct AppLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        AppLauncher()
//    }
//}
