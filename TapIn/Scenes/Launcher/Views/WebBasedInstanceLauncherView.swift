import SwiftUI

struct WebBasedInstanceLauncherView: View {
    @State var instance: any WebBasedBehavior & BaseLauncherInstanceBehavior
    
    @State private var hideOnLaunch = false
    
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
            
            if instance.object.instantiated
            {
                HStack {
                    Toggle("Hide app on launch", isOn: $hideOnLaunch)
                        .toggleStyle(.checkbox)
                        .onChange(of: hideOnLaunch) { value in
                            instance.write {
                                instance.object.hideOnLaunch = value
                            }
                        }
                    
                    Spacer()
                    
                    Text("Delay launch?")
                }
            }
        }
        .padding()
        .onAppear {
            hideOnLaunch = instance.object.hideOnLaunch
        }
    }
}

//struct WebBasedInstanceLauncherView_Previews: PreviewProvider {
//    static var previews: some View {
//        WebBasedInstanceLauncherView()
//    }
//}
