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
            },
            onSubmitChangeName: {(name) in
                sidebarState.rename(listItem, name: name)
            }
        )
    }
}
