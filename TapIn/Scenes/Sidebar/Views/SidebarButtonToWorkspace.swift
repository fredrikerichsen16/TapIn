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
            .tag(menuItem)
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
            Button("Add workspace to folder") {
                sidebarVM.addWorkspace(to: workspace.folder)
            }
            
            Button("Delete") {
                sidebarVM.delete(workspace: workspace)
            }

            Button("Rename") {
                beginRenamingWorkspace()
            }
            
            Button("Settings") {
                let settingsWindowSelectorName: String
                
                if #available(macOS 13.0, *) {
                    settingsWindowSelectorName = "showSettingsWindow:"
                } else {
                    settingsWindowSelectorName = "showPreferencesWindow:"
                }
                
                NSApp.sendAction(Selector((settingsWindowSelectorName)), to: nil, from: nil)
            }
        }
    }

    func beginRenamingWorkspace() {
        renameWorkspaceField = workspace.name
        isRenaming = true
    }
}
