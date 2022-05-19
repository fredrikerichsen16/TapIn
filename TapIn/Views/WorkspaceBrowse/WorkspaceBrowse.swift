import SwiftUI
import SwiftUIRouter
import RealmSwift

struct WorkspaceBrowse: View {
    @Environment(\.realm) var realm
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var stateManager: StateManager
    @ObservedRealmObject var workspace: WorkspaceDB
    
    @State var bottomMenuControllerSelection = BottomMenuControllerSelection.pomodoro

    var body: some View {
		VStack {
            SectionPicker()

			SwitchRoutes {
				Route("workspace-pomodoro") {
                    WorkspacePomodoro(pomodoroState: stateManager.getPomodoroState(realm: realm, ws: workspace))
                        .onAppear {
                            bottomMenuControllerSelection = .pomodoro
                        }
				}
				Route("workspace-timetracking") { info in
                    WorkspaceTimeTracking(timeTracker: workspace.timeTracker!)
				}
				Route("workspace-launcher/*") {
                    WorkspaceLauncher(launcher: workspace.launcher!)
                        .onAppear {
                            bottomMenuControllerSelection = .launcher
                        }
				}
				Route("workspace-blocker") {
                    WorkspaceBlocker(blocker: workspace.blocker!)
                        .onAppear {
                            bottomMenuControllerSelection = .blocker
                        }
				}
			}

            Spacer()

            BottomMenu(
                launcher: workspace.launcher!,
                pomodoroState: stateManager.getPomodoroState(realm: realm, ws: workspace),
                bottomMenuControllerSelection: $bottomMenuControllerSelection
            )
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
