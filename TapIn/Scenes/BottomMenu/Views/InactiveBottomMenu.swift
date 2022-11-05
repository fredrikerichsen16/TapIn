import SwiftUI

struct InactiveBottomMenu: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var sidebar: SidebarVM
    @StateObject var activeWorkspace: WorkspaceDB
    
    var body: some View {
        HStack {
            VStack {
                Text("Active Workspace: \(activeWorkspace.name)")
                HStack {
                    Button("Go to", action: {
                        sidebar.objectWillChange.send()
                        sidebar.sidebarModel.selection = MenuItem.workspace(activeWorkspace)
                    })
                    Button("Cancel", action: {
                        workspaceCoordinator.disactivate()
                    })
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 6)
        .background(Color(r: 37, g: 37, b: 42, opacity: 1))
    }
}
