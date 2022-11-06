import SwiftUI

struct DefaultAppSelectorView: View {
    @StateObject var vm: DefaultAppSelectorVM
    
    var body: some View {
        VStack {
            Text("Open file with app...")
            
            Picker("", selection: $vm.selection) {
                ForEach(vm.compatibleApps) { app in
                    HStack {
                        Image(nsImage: app.icon)
                        Text(app.name)
                    }.tag(app.id)
                }
                .frame(width: 200, alignment: .center)
                .pickerStyle(PopUpButtonPickerStyle())
                .onChange(of: vm.selection) { value in
                    vm.didChangeSelection(value)
                }
            }
        }
    }
}

class DefaultAppSelectorVM: ObservableObject {
    init(instance: any BaseLauncherInstanceBehavior & FileBehavior) {
        self.instance = instance
        self.compatibleApps = instance.getCompatibleApps().map({ CompatibleApp(url: $0) })
        self.selection = UUID()
        self.selection = compatibleApps[0].id
    }
    
    @Published var instance: any BaseLauncherInstanceBehavior & FileBehavior
    @Published var compatibleApps: [CompatibleApp]
    @Published var selection: UUID
    
    func didChangeSelection(_ value: UUID) {
        guard let selectedApp = compatibleApps.first(where: { $0.id == value }) else {
            return
        }
        
        instance.write {
            instance.object.appUrl = selectedApp.url
        }
    }
}

struct CompatibleApp: Identifiable {
    let id = UUID()
    let url: URL
    let name: String
    let icon: NSImage
    
    init(url: URL) {
        self.url = url
        self.name = applicationReadableName(url: url)
        self.icon = getAppIcon(for: url, size: 16)
    }
}
