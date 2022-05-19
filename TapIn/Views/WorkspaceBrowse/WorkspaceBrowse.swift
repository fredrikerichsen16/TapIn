import SwiftUI
import SwiftUIRouter
import RealmSwift

//struct WorkspaceBrowse: View {
//    @Environment(\.realm) var realm
//    @ObservedRealmObject var workspaceDB: WorkspaceDB
//
//    var body: some View {
//        List {
//            Text("Hello!")
//            Text(workspaceDB.name)
//            Text(String(workspaceDB.id))
//
//            if let pomodoro = workspaceDB.pomodoro {
//                Text("Duration: \(pomodoro.pomodoroDuration)")
//            }
//
//            if let timer = workspaceDB.timeTracker {
//                Text("Timer ID: \(timer.id)")
//            }
//
//            Button("Change") {
//                guard let thawed = workspaceDB.thaw() else { return }
//
//                try! thawed.realm!.write {
//                    thawed.name = "Calculus"
//                }
//            }
//        }
//    }
//        VStack {
//            List {
//                Text(recreateWorkspaces())
//
//                if let pomodoro = workspaceDB.pomodoro {
//                    Text("Long break duration \(pomodoro.longBreakDuration)")
//                    Text("Pomodoro ID: \(pomodoro.id)")
//                }
//
//                if let blocker = workspaceDB.blocker {
//                    Text("Blocker ID \(blocker.id)")
//                }
//
//                if let timeTracker = workspaceDB.timeTracker {
//                    Text("Time Tracker ID \(timeTracker.id)")
//                }
//
//                Button("Change Pomodoro Duration") {
//                    let pomodoroThawed = workspaceDB.pomodoro!.thaw()
//                    let pomodoroRealm = pomodoroThawed!.realm!
//
//                    try! pomodoroRealm.write {
//                        pomodoroThawed!.pomodoroDuration = 100
//                    }
//                }
//            }
//
//            BottomMenu()
//        }
//        .edgesIgnoringSafeArea([.bottom, .horizontal])
//}

struct WorkspaceBrowse: View {
    @Environment(\.realm) var realm
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var stateManager: StateManager
    @ObservedRealmObject var workspace: WorkspaceDB

    var body: some View {
		VStack {
            SectionPicker()

			SwitchRoutes {
				Route("workspace-pomodoro") {
                    WorkspacePomodoro(pomodoro: workspace.pomodoro!)
				}
				Route("workspace-timetracking") { info in
                    WorkspaceTimeTracking(timeTracker: workspace.timeTracker!)
				}
				Route("workspace-launcher/*") {
                    WorkspaceLauncher(launcher: workspace.launcher!)
				}
				Route("workspace-blocker") {
                    WorkspaceBlocker(blocker: workspace.blocker!)
				}
			}

            Spacer()

            BottomMenu(launcher: workspace.launcher!)
		}
        .edgesIgnoringSafeArea([.bottom, .horizontal])
		.onAppear {
            print("SELECTED ")
            print(workspace.name)
            stateManager.selectedWorkspace = workspace
            
			navigator.navigate("/workspace-pomodoro")
		}
    }
}
