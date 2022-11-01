import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, workspace
    }
    
    @State private var selection: Tabs = .general
    
    var body: some View {
        TabView(selection: $selection) {
            GeneralSettingsView()
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            WorkspaceSettingsView()
                .tabItem {
                    Label("Workspaces", systemImage: "star")
                }
                .tag(Tabs.workspace)
        }
        .padding(20)
        .frame(width: 375, height: 150)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
