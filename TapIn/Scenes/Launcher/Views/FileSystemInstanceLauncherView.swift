import SwiftUI

struct FileSystemInstanceLauncherView: View {
    @State var instance: any FileSystemBasedBehavior & BaseLauncherInstanceBehavior
    
    var body: some View {
        VStack {
            Spacer()
            
            TappableAppIconView(instance: instance, onSubmitFile: { url in
                instance.submittedFileWithPanel(url: url)
            })
            
            EditableLauncherNameView(name: instance.name, onSubmit: { name in
                instance.write {
                    instance.object.name = name
                }
            })
            
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
