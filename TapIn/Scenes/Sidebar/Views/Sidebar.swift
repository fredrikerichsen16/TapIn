import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var stateManager: StateManager
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
                
                Text(sidebarVM.sidebarSelection ?? "?")
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 180, maxWidth: 250)
            .padding(.top)
        }
    }
    
}
