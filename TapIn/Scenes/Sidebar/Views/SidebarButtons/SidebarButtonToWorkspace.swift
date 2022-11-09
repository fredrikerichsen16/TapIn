import SwiftUI

struct SidebarButtonToWorkspace: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var sidebarState: SidebarState
    @State var sidebarListItem: SidebarListItem
    
    var workspace: WorkspaceDB {
        sidebarListItem.workspace!
    }
    
    var body: some View {
        DynamicSidebarButton(
            sidebarListItem: sidebarListItem,
            destination: {
                Text("pikk")
//                WorkspaceView()
//                    .environmentObject(workspaceCoordinator.getWorkspaceVM(for: workspace))
            },
            contextMenu: {
                Button("Add workspace to folder") {
                    sidebarState.addWorkspace(to: workspace.folder)
                }
                
                Button("Delete") {
                    sidebarState.delete(workspace: workspace)
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
            },
            onSubmitChangeName: {(name) in
                sidebarState.renameWorkspace(workspace, name: name)
            }
        )
    }
}
