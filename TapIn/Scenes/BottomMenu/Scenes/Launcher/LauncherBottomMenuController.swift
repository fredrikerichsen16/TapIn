import SwiftUI

struct LauncherBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .launcher) {
            Button("Launch") {
                workspace.launcher.openAll()
            }
        }
    }
}
