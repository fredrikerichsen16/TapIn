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
                        sidebar.selectListItem(by: activeWorkspace)
                    })
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.vertical, 6)
    }
}
