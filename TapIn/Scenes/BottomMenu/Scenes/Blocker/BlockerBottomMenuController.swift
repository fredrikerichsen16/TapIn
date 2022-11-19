import SwiftUI

struct BlockerBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: BlockerState {
        workspace.blocker
    }
    
    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .blocker) {
            HStack {
                if vm.isActive
                {
                    Button("Stop Blocking") {
                        vm.endSession()
                    }
                    .errorAlert(error: $workspace.blocker.error)
                    .onAppear {
                        vm.error = nil
                    }
                }
                else
                {
                    Button("Start Blocking") {
                        vm.startSession()
                    }
                }
            }
        }
    }
}
