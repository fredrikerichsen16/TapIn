import SwiftUI

struct WebBasedInstanceLauncherView: View {
    @State var instance: any WebBasedBehavior & BaseLauncherInstanceBehavior

    var body: some View {
        VStack {
            Spacer()
            
            Image(nsImage: instance.getIcon(size: 128))
            
            WebInstanceNameAndUrlEditorView(instance: instance)
            
            if let openableInstance = instance as? Openable {
                Button("Open") {
                    openableInstance.open()
                }
            }
            
            if let fileInstance = instance as? any BaseLauncherInstanceBehavior & FileBehavior {
                DefaultAppSelectorView(vm: DefaultAppSelectorVM(instance: fileInstance))
            }
            
            Spacer()
            
            BottomBarLauncherSettingsView(instance: instance)
        }
        .padding()
    }
}
