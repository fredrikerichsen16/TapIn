import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var sidebarVM: SidebarVM
    
    var body: some View {
        NavigationView {
            List(selection: $sidebarVM.sidebarSelection) {
                Section(header: Text("")) {
                    SidebarButtonToPage(menuItem: MenuItem.home)
                    SidebarButtonToPage(menuItem: MenuItem.statistics)
                }
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(sidebarVM.workspaceMenuItems, children: \.children) { menuItemNode in
                        SidebarButtonToWorkspace(menuItem: menuItemNode.menuItem)
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                Button("Add Workspace", action: {
                    sidebarVM.addWorkspace()
                })
                
                Button("Settings") {
                    if #available(macOS 13.0, *) {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    } else {
                        NSApp.sendAction(Selector(("showPreferencesWindow:")), to: nil, from: nil)
                    }
                }
                
                Text(sidebarVM.sidebarSelection ?? "?")
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 180, maxWidth: 250)
            .padding(.top)
        }
    }
    
}

extension Sidebar {
    
}
