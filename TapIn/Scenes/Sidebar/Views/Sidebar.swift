import SwiftUI

struct Sidebar: View {
    @EnvironmentObject var stateManager: StateManager
    
    @StateObject var vm: SidebarVM
    
    init(stateManager: StateManager) {
        self._vm = StateObject(wrappedValue: SidebarVM(stateManager: stateManager))
    }
    
    var body: some View {
        NavigationView {
            List(selection: $stateManager.sidebarSelection) {
                Section(header: Text("")) {
                    SidebarButtonToPage(menuItem: MenuItem.home)
                    SidebarButtonToPage(menuItem: MenuItem.statistics)
                }
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(stateManager.workspaceMenuItems, children: \.children) { menuItemNode in
                        SidebarButtonToWorkspace(vm: vm, menuItem: menuItemNode.menuItem)
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                Button("Add Workspace", action: {
                    vm.addWorkspace()
                })
                
                Text(stateManager.sidebarSelection ?? "?")
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 180, maxWidth: 250)
            .padding(.top)
        }
    }
    
}

extension Sidebar {
    
}
