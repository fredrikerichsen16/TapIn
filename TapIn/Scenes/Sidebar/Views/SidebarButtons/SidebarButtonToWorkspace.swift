import SwiftUI

struct SidebarButtonToWorkspace: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var sidebarState: SidebarState
    @State var listItem: SidebarListItem
    
    var body: some View {
        DynamicSidebarButton(
            listItem: listItem,
            destination: {
                if let workspace = listItem.getWorkspace()
                {
                    WorkspaceView()
                        .environmentObject(workspaceCoordinator.getWorkspaceVM(for: workspace))
                }
                else
                {
                    EmptyView()
                }
            },
            contextMenu: {
                Button("Delete") {
                    sidebarState.delete(workspace: listItem)
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
                sidebarState.rename(listItem, name: name)
            }
        )
    }
}
