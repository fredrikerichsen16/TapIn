import SwiftUI

struct PomodoroBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState

    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .pomodoro) {
            HStack {
                ForEach(workspace.pomodoro.getButtons(), id: \.rawValue) { button in
                    PomodoroButtonView(button: button)
                }
            }
        }
    }
}
