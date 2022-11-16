import SwiftUI

struct BottomBarLauncherSettingsView: View {
    @State var instance: any BaseLauncherInstanceBehavior
    @State private var hideOnLaunch = false
    @State private var disabled = false
    
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
                
                Toggle("Disactivate", isOn: $disabled)
                    .toggleStyle(.checkbox)
                    .onChange(of: disabled) { value in
                        instance.write {
                            instance.object.active = !disabled
                        }
                    }
            }
            .padding()
            .onAppear {
                hideOnLaunch = instance.object.hideOnLaunch
                disabled = !instance.object.active
            }
        }
        else
        {
            EmptyView()
        }
    }
}
