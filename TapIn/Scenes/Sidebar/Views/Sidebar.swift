import SwiftUI

struct Sidebar: View {
    @StateObject var vm: SidebarVM
    
    init(stateManager: StateManager) {
        self._vm = StateObject(wrappedValue: SidebarVM(stateManager: stateManager))
    }
    
    var body: some View {
        NavigationView {
            List(selection: $vm.sidebarSelection) {
                Section(header: Text("")) {
                    SidebarButtonToPage(vm: vm, menuItem: MenuItem.home)
                    SidebarButtonToPage(vm: vm, menuItem: MenuItem.statistics)
                }
                
                Section(header: Text("Workspaces")) {
                    OutlineGroup(vm.workspaceMenuItems, children: \.children) { menuItemNode in
                        SidebarButtonToWorkspace(vm: vm, menuItem: menuItemNode.menuItem)
                    }
                }
                .collapsible(false)
                
                Spacer()
                
                Button("Add Workspace", action: {
                    vm.addWorkspace()
                })
                Text(vm.sidebarSelection ?? "?")
            }
            .listStyle(SidebarListStyle())
            .frame(minWidth: 180, maxWidth: 250)
            .padding(.top)
        }
    }
    
}
