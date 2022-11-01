import SwiftUI
import RealmSwift

struct ActiveBottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceVM

    var body: some View {
        HStack(alignment: .center) {
            Spacer()
            
            navigateButton(direction: .left)

            switch workspace.workspaceTab
            {
            case .pomodoro:
                PomodoroBottomMenuController()
                    .padding()
            case .timetracking:
                Text("Tracker")
            case .launcher:
                LauncherBottomMenuController()
                    .padding()
            case .blocker:
                BlockerBottomMenuController()
                    .padding()
            case .radio:
                RadioBottomMenuController()
            }
            
            navigateButton(direction: .right)
            
            Spacer()
        }
    }

    private func navigateButton(direction: Direction) -> some View {
        var action: () -> Void = {}
        var icon: String = ""

        if direction == .right
        {
            action = { workspace.workspaceTab.next() }
            icon = "chevron.right"
        }
        else
        {
            action = { workspace.workspaceTab.previous() }
            icon = "chevron.left"
        }

        return Button(action: action, label: {
            Image(systemName: icon)
        }).buttonStyle(PlainButtonStyle())
    }
}

struct BlockerBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceVM
    @EnvironmentObject var sidebar: SidebarVM
    
    var body: some View {
        VStack {
            Text("Blocker").font(.body)
            
            HStack {
                Button("Start") {
                    WorkspaceVM.current = workspace
                    sidebar.activeWorkspace = workspace.workspace
                }
                
                Button("End") {
                    WorkspaceVM.current = nil
                    sidebar.activeWorkspace = nil
                }
            }
        }
    }
}

struct LauncherBottomMenuController: View {
    @EnvironmentObject var launcherState: LauncherState
    
    var body: some View {
        VStack {
            Text("Launcher").font(.body)
            
            Button("Launch") {
                launcherState.launcher.openAll()
            }
        }
    }
}

struct PomodoroBottomMenuController: View {
    @EnvironmentObject var pomodoroState: PomodoroState

    var body: some View {
        VStack {
            Text("Pomodoro").font(.body)
            pomodoroState.getButtons()
        }
    }
}
