import SwiftUI

struct BottomMenu: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceState
    
    let height: CGFloat = 80.0
    
    var body: some View {
        if let activeWorkspaceState = workspaceCoordinator.getActiveWorkspace(), activeWorkspaceState.workspace != workspace.workspace
        {
            InactiveBottomMenu(activeWorkspace: activeWorkspaceState.workspace)
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color("BottomMenuColor"))
        }
        else
        {
            ActiveBottomMenu()
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color("BottomMenuColor"))
        }
    }
}
