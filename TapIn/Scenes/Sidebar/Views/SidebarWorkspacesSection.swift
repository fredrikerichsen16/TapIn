import SwiftUI
import RealmSwift

struct MenuItemNode: Identifiable {
    var id = UUID()
    var menuItem: MenuItem
    var children: [MenuItemNode]? = nil
    
    static func createOutline(workspaces: [WorkspaceDB]) -> [MenuItemNode] {
        var menuItemNodes: [MenuItemNode] = workspaces.map({ MenuItemNode(menuItem: .workspace($0)) })
        
        for i in 0..<menuItemNodes.count
        {
            let children = Array(workspaces[i].children)
            
            if children.count > 0 {
                menuItemNodes[i].children = children.map({ MenuItemNode(menuItem: .workspace($0)) })
            }
        }
        
        return menuItemNodes
    }
}

//class SidebarWorkspacesSectionModel: ObservableObject {
//    let stateManager: StateManager
//    let realm: Realm
//
//    init(stateManager: StateManager) {
//        self.stateManager = stateManager
//        self.realm = RealmManager.shared.realm
//
//        self.setWorkspaceMenuItems()
//    }
//
//    @Published var workspaceMenuItems: [MenuItemNode] = []
//
//    private func setWorkspaceMenuItems() {
//        let workspaces = realm.objects(WorkspaceDB.self).where { $0.parent.count == 0 }
//
//        self.workspaceMenuItems = MenuItemNode.createOutline(workspaces: Array(workspaces))
//    }
//
//    func addWorkspace() {
//        try? realm.write({
//            let ws = WorkspaceDB(name: "New Workspace")
//
//            realm.add(ws)
//        })
//    }
//}
//
//struct SidebarWorkspacesSection: View {
//    @StateObject var vm: SidebarWorkspacesSectionModel
//
//    init(stateManager: StateManager) {
//        self._vm = StateObject(wrappedValue: SidebarWorkspacesSectionModel(stateManager: stateManager))
//    }
//
//    var realm: Realm {
//        RealmManager.shared.realm
//    }
//
//    var body: some View {
//        Section(header: Text("Workspaces")) {
//            OutlineGroup(vm.workspaceMenuItems, children: \.children) { menuItemNode in
//                SidebarButtonToWorkspace(menuItem: menuItemNode.menuItem)
//            }
//
//            Spacer()
//
//            Button("Add Workspace", action: vm.addWorkspace)
//        }
//        .collapsible(false)
//    }
//}

//struct SidebarDisclosure: View {
//    var menuItem: MenuItem
//    var workspaces: [WorkspaceDB]
//
//    @State var isExpanded = false
//
//    var body: some View {
//        DisclosureGroup(isExpanded: $isExpanded, content: {
//            ForEach(MenuItem.getMenuItems(workspaces: workspaces), id: \.id) { item in
//                SidebarButton(menuItem: item, selection: $selection)
//            }
//        }, label: {
//            SidebarButton(menuItem: menuItem, selection: $selection)
//        })
//    }
//}

//struct SidebarWorkspacesSection_Previews: PreviewProvider {
//    static var previews: some View {
//        SidebarWorkspacesSection()
//    }
//}
