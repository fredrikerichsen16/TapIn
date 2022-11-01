import SwiftUI

struct SidebarButtonToWorkspace: View {
    @EnvironmentObject var sidebarVM: SidebarVM
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
                    sidebarVM.renameWorkspace(workspace, name: renameWorkspaceField)
                    isRenaming = false
                }
        }
        else
        {
            NavigationLink(destination: {
                WorkspaceBrowseIntermediate()
                    .environmentObject(WorkspaceVM.getCurrent(for: workspace))
            }) {
                Label(menuItem.label, systemImage: menuItem.icon)
                    .padding(.vertical, 5)
            }
            .tag(menuItem.id)
            .contextMenu(ContextMenu(menuItems: {
                contextMenu
            }))
        }
    }
}

// MARK: Context Menu
extension SidebarButtonToWorkspace {
    var contextMenu: some View {
        Group {
            Button("Add Child Workspace") {
                sidebarVM.addChild(to: workspace)
            }

            Button("Delete") {
                sidebarVM.deleteWorkspace(workspace)
            }

            Button("Rename") {
                beginRenamingWorkspace()
            }
        }
    }

    func beginRenamingWorkspace() {
        renameWorkspaceField = workspace.name
        isRenaming = true
    }
}
