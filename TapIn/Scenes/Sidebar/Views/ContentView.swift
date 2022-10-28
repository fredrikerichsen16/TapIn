import SwiftUI
import SwiftUIRouter
import RealmSwift

struct ContentView: View {
    @EnvironmentObject var stateManager: StateManager
    
    var body: some View {
        Router {
            NavigationView {
                SwiftUI.List(selection: $stateManager.sidebarSelection) {
                    Section(header: Text("")) {
                        SidebarButtonToPage(menuItem: MenuItem.home)
                        SidebarButtonToPage(menuItem: MenuItem.statistics)
                    }
                    
                    Section(header: Text("Workspaces")) {
                        OutlineGroup(stateManager.workspaceMenuItems, children: \.children) { menuItemNode in
                            SidebarButtonToWorkspace(menuItem: menuItemNode.menuItem)
                        }
                    }
                    .collapsible(false)
                    
                    Spacer()
                    
                    Button("Add Workspace", action: { print("x") })
                    Text(stateManager.sidebarSelection ?? "?")
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 180, maxWidth: 250)
                .padding(.top)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//	static var previews: some View {
//		ContentView()
//	}
//}
