import SwiftUI
import RealmSwift

struct ActiveBottomMenu: View {
    @EnvironmentObject var workspace: WorkspaceVM

    var body: some View {
        HStack(alignment: .center) {
            navigateButton(direction: .left)
            
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
            
            navigateButton(direction: .right)
        }
        .padding(.horizontal, 15)
    }

    private func navigateButton(direction: Direction) -> some View {
        var action: () -> Void = {}
        var icon: String = ""

        if direction == .right
        {
            action = { workspace.bottomMenuTab.next() }
            icon = "chevron.right"
        }
        else
        {
            action = { workspace.bottomMenuTab.previous() }
            icon = "chevron.left"
        }

        return Button(action: action, label: {
            Image(systemName: icon)
        })
    }
}

struct TimeTrackerBottomMenuController: View {
    @EnvironmentObject var timeTracker: TimeTrackerState
    
    var body: some View {
        VStack {
            Text("Time Tracker").font(.body)
            
            HStack {
                if timeTracker.isActive
                {
                    Button("Stop Time Tracker") {
                        timeTracker.endSession()
                    }
                }
                else
                {
                    Button("Start Time Tracker") {
                        timeTracker.startSession()
                    }
                }
            }
        }
    }
}

struct BlockerBottomMenuController: View {
    @EnvironmentObject var blocker: BlockerState
    
    var body: some View {
        VStack {
            Text("Blocker").font(.body)
            
            HStack {
                if blocker.isActive
                {
                    Button("Stop Blocking") {
                        blocker.endSession()
                    }
                }
                else
                {
                    Button("Start Blocking") {
                        blocker.startSession()
                    }
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
            HStack {
                ForEach(pomodoroState.getButtons(), id: \.rawValue) { button in
                    PomodoroButtonView(button: button)
                }
            }
        }
    }
}

struct PomodoroButtonView: View {
    @Environment(\.workspaceCoordinator) var workspaceCoordinator
    @EnvironmentObject var pomodoroState: PomodoroState
    let button: PomodoroButton
    
    var body: some View {
        switch button
        {
        case .start, .resume:
            Button(button.rawValue, action: pomodoroState.startSession)
        case .pause:
            Button(button.rawValue, action: pomodoroState.pauseSession)
        case .cancel, .skip:
            Button(button.rawValue, action: pomodoroState.cancelSession)
        }
    }
}
