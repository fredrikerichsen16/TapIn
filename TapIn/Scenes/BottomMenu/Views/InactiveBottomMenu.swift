import SwiftUI

struct InactiveBottomMenu: View {
    @EnvironmentObject var sidebar: SidebarState
    @StateObject var activeWorkspace: WorkspaceDB
    
    var body: some View {
        HStack {
            VStack {
                Text("Active Workspace: \(activeWorkspace.name)")
                HStack {
                    Button("Go to", action: {
                        sidebar.sidebarModel.selection = SidebarListItem.workspace(activeWorkspace)
                    })
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 6)
        .background(Color(r: 37, g: 37, b: 42, opacity: 1))
    }
}
