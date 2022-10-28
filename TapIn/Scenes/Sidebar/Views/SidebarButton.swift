import SwiftUI
import RealmSwift

struct SidebarButtonToPage: View {
    @State var menuItem: MenuItem
    
    var body: some View {
        NavigationLink(destination: { viewForMenuItem(menuItem) }) {
            Label(menuItem.label, systemImage: menuItem.icon)
                .padding(.vertical, 5)
                .tag(menuItem.id)
        }
    }
    
    @ViewBuilder
    private func viewForMenuItem(_ item: MenuItem) -> some View {
        switch item
        {
        case .home:
            Text(item.label).font(.largeTitle)
        case .statistics:
            Text(item.label).font(.largeTitle)
        default:
            fatalError("1493403")
        }
    }
}

struct SidebarButtonToWorkspace: View {
    var realm: Realm {
        RealmManager.shared.realm
    }

    @EnvironmentObject var stateManager: StateManager
    @State var menuItem: MenuItem
    
    var workspace: WorkspaceDB {
        menuItem.workspace!
    }

    @State var renameWorkspaceField: String = ""
    @State var isRenaming = false

    @Namespace var mainNamespace

    var body: some View {
        if isRenaming
        {
            TextField("", text: $renameWorkspaceField) // passing it to bind
                .textFieldStyle(.roundedBorder) // adds border
                .prefersDefaultFocus(in: mainNamespace)
                .onSubmit {
                    workspace.renameWorkspace(realm, name: renameWorkspaceField)
                    isRenaming = false
                }
        }
        else
        {
            NavigationLink(destination: { WorkspaceBrowse(workspace: workspace) }) {
                Label(menuItem.label, systemImage: menuItem.icon)
                    .padding(.vertical, 5)
                    .tag(menuItem.id)
            }
            .contextMenu(ContextMenu(menuItems: {
                contextMenu
            }))
        }
    }

//    @ViewBuilder
//    private func viewForMenuItem(_ item: MenuItem) -> some View {
//        switch item
//        {
//        case .workspace(let ws):
//            WorkspaceBrowse(workspace: ws)
//        default:
//            fatalError("18423403")
//        }
//    }
}

// MARK: Context Menu
extension SidebarButtonToWorkspace {
    var contextMenu: some View {
        Group {
            Button("Add Child Workspace") {
                workspace.addChild(realm)
            }

            Button("Delete") {
                stateManager.sidebarSelection = MenuItem.home.id
                WorkspaceDB.deleteWorkspace(realm, workspace: workspace)
            }

            Button("Rename") {
                beginRenamingWorkspace()
            }

            Button("Test") {
                stateManager.sidebarSelection = nil
            }
        }
    }
    
    func beginRenamingWorkspace() {
        renameWorkspaceField = workspace.name
        isRenaming = true
    }
}

//struct SidebarButton_Previews: PreviewProvider {
//    @State var selection: String? = "statistics"
//
//    static var previews: some View {
//        SidebarButton(menuItem: .statistics, selection: $selection)
//    }
//}
