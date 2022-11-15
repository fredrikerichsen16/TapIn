import SwiftUI
import RealmSwift

struct ActiveBottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceState

    var body: some View {
        HStack(alignment: .center) {
            navigateButton(.left)
            
            Spacer()

            switch workspace.bottomMenuTab
            {
            case .pomodoro:
                PomodoroBottomMenuController()
                    .padding()
            case .timetracking:
                TimeTrackerBottomMenuController()
            case .launcher:
                LauncherBottomMenuController()
                    .padding()
            case .blocker:
                BlockerBottomMenuController()
                    .padding()
            case .radio:
                RadioBottomMenuController()
            default:
                EmptyView()
            }
            
            Spacer()
            
            navigateButton(.right)
        }
        .padding(.horizontal, 15)
    }
    
    @ViewBuilder
    func navigateButton(_ direction: Direction) -> some View {
        if direction == .left
        {
            Button(action: { workspace.bottomMenuTab.previous() }, label: {
                Image(systemName: IconKeys.left)
            })
        }
        else
        {
            Button(action: { workspace.bottomMenuTab.next() }, label: {
                Image(systemName: IconKeys.right)
            })
        }
    }
}

struct TimeTrackerBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: TimeTrackerState {
        workspace.timeTracker
    }
    
    var body: some View {
        BottomMenuWorkspaceTabController(workspaceTab: .timetracking) {
            HStack {
                if vm.isActive
                {
                    Button("Stop Time Tracker") {
                        vm.endSession()
                    }
                }
                else
                {
                    Button("Start Time Tracker") {
                        vm.startSession()
                    }
                }
            }
        }
    }
}

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
                        vm.requestEndSession(sessionIsInProgress: workspace.componentActivityTracker.sessionIsInProgress())
                    }
                    .errorAlert(error: $workspace.blocker.error)
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

struct PomodoroButtonView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var workspace: WorkspaceState
    let button: PomodoroButton
    
    var body: some View {
        switch button
        {
        case .start, .resume:
            Button(button.rawValue, action: workspace.pomodoro.startSession)
        case .pause:
            Button(button.rawValue, action: workspace.pomodoro.pauseSession)
        case .cancel, .skip:
            Button(button.rawValue, action: workspace.pomodoro.cancelSession)
        }
    }
}


struct BottomMenuWorkspaceTabController<Content>: View where Content: View {
    let workspaceTab: WorkspaceTab
    let content: Content
    
    init(workspaceTab: WorkspaceTab, @ViewBuilder content: () -> Content) {
        self.workspaceTab = workspaceTab
        self.content = content()
    }
    
    var body: some View {
        VStack {
            Text(workspaceTab.label).font(.body)
            
            content
        }
    }
}
