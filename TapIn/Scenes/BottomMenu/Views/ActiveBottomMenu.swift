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
    @EnvironmentObject var workspace: WorkspaceVM
    
    var body: some View {
        VStack {
            Text("Time Tracker").font(.body)
            
            HStack {
                if workspace.timeTracker.isActive
                {
                    Button("Stop Time Tracker") {
                        workspace.timeTracker.endSession()
                    }
                }
                else
                {
                    Button("Start Time Tracker") {
                        workspace.timeTracker.startSession()
                    }
                }
            }
        }
    }
}

struct BlockerBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    var body: some View {
        VStack {
            Text("Blocker").font(.body)
            
            HStack {
                if workspace.blocker.isActive
                {
                    Button("Stop Blocking") {
                        workspace.blocker.endSession()
                    }
                }
                else
                {
                    Button("Start Blocking") {
                        workspace.blocker.startSession()
                    }
                }
            }
        }
    }
}

struct LauncherBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    var body: some View {
        VStack {
            Text("Launcher").font(.body)
            
            Button("Launch") {
                workspace.launcher.launcher.openAll()
            }
        }
    }
}

struct PomodoroBottomMenuController: View {
    @EnvironmentObject var workspace: WorkspaceVM

    var body: some View {
        VStack {
            Text("Pomodoro").font(.body)
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
    @EnvironmentObject var workspace: WorkspaceVM
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
