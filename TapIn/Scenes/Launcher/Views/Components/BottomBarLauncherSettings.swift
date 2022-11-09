import SwiftUI

struct BottomBarLauncherSettingsView: View {
    @State var instance: any BaseLauncherInstanceBehavior
    @State private var hideOnLaunch = false
    
    var body: some View {
        if instance.object.instantiated
        {
            HStack {
                Toggle("Hide \(instance.type.label.lowercased()) on launch", isOn: $hideOnLaunch)
                    .toggleStyle(.checkbox)
                    .onChange(of: hideOnLaunch) { value in
                        instance.write {
                            instance.object.hideOnLaunch = value
                        }
                    }
                
                Spacer()
                
                Text("Delay launch?")
            }
            .onAppear {
                hideOnLaunch = instance.object.hideOnLaunch
            }
        }
        else
        {
            EmptyView()
        }
    }
}
