import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, workspace, sidebar
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
            
            SidebarSettingsView()
                .tabItem {
                    Label("Sidebar/Workspaces", systemImage: "star")
                }
                .tag(Tabs.sidebar)
        }
        .frame(minWidth: 300, idealWidth: 450, maxWidth: 1200, minHeight: 300, idealHeight: 450, maxHeight: 1200, alignment: .center)
        .padding(20)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
