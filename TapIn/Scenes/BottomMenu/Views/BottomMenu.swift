import SwiftUI

struct BottomMenu: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspaceVM: WorkspaceVM
    
    let height: CGFloat = 80.0
    
    var body: some View {
        if let activeWorkspaceVM = workspaceCoordinator.getActiveWorkspace(), activeWorkspaceVM.workspace != workspaceVM.workspace
        {
            InactiveBottomMenu(activeWorkspace: activeWorkspaceVM.workspace)
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
        else
        {
            ActiveBottomMenu()
                .frame(maxWidth: .infinity, minHeight: height, idealHeight: height, maxHeight: height, alignment: .center)
                .background(Color(r: 37, g: 37, b: 42, opacity: 1))
        }
    }
}
