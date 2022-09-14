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
            
            Spacer()

            SwitchRoutes {
                Route("workspace-pomodoro") {
                    WorkspacePomodoro(pomodoroState: stateManager.getPomodoroState(realm: realm, workspace: workspace))
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

            if shouldShowInactiveBottomMenu()
            {
                InactiveBottomMenu()
            }
            else
            {
                BottomMenu(
                    workspace: workspace,
                    pomodoroState: stateManager.getPomodoroState(realm: realm, workspace: workspace),
                    bottomMenuControllerSelection: $bottomMenuControllerSelection
                )
            }
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
        .onAppear {
            stateManager.selectedWorkspace = workspace
            navigator.navigate("/workspace-pomodoro")
        }
    }
    
    func shouldShowInactiveBottomMenu() -> Bool {
        return stateManager.activeWorkspace != nil && stateManager.activeWorkspace != workspace
    }
}


//struct WorkspaceBrowse: View {
//    @Environment(\.realm) var realm
//    @EnvironmentObject var navigator: Navigator
//    @EnvironmentObject var stateManager: StateManager
//    @ObservedRealmObject var workspace: WorkspaceDB
//
//    @State var bottomMenuControllerSelection = BottomMenuControllerSelection.pomodoro
//
//    var body: some View {
//		VStack {
//            SectionPicker()
//
//			SwitchRoutes {
//				Route("workspace-pomodoro") {
//                    WorkspacePomodoro(pomodoroState: stateManager.getPomodoroState(realm: realm, workspace: workspace))
//                        .onAppear {
//                            bottomMenuControllerSelection = .pomodoro
//                        }
//				}
//				Route("workspace-timetracking") { info in
//                    WorkspaceTimeTracking(timeTracker: workspace.timeTracker!)
//				}
//				Route("workspace-launcher/*") {
//                    WorkspaceLauncher(launcher: workspace.launcher!)
//                        .onAppear {
//                            bottomMenuControllerSelection = .launcher
//                        }
//				}
//				Route("workspace-blocker") {
//                    WorkspaceBlocker(blocker: workspace.blocker!)
//                        .onAppear {
//                            bottomMenuControllerSelection = .blocker
//                        }
//				}
//			}
//
//            Spacer()
//
//            Text(stateManager.selectedWorkspace!.name)
//
//            Spacer()
//
//            BottomMenu(
//                workspace: workspace,
//                pomodoroState: stateManager.getPomodoroState(realm: realm, workspace: workspace),
//                bottomMenuControllerSelection: $bottomMenuControllerSelection
//            )
//		}
//        .edgesIgnoringSafeArea([.bottom, .horizontal])
////		.onAppear {
////            print("SELECTED ")
////            print(workspace.name)
////            stateManager.selectedWorkspace = workspace
////
////			navigator.navigate("/workspace-pomodoro")
////		}
//    }
//}
