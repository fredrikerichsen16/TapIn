import SwiftUI
import SwiftUIRouter
import RealmSwift

struct WorkspaceBrowse: View {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    @EnvironmentObject var navigator: Navigator
    @EnvironmentObject var stateManager: StateManager
    
    var workspace: WorkspaceDB? {
        stateManager.selectedWorkspace
    }
    
    @State var bottomMenuControllerSelection = BottomMenuControllerSelection.pomodoro
    
    var body: some View {
        if let workspace = workspace
        {
            VStack {
                SectionPicker()
                
                Spacer()

                SwitchRoutes {
                    Route("workspace-pomodoro") {
                        WorkspacePomodoro(pomodoroState: stateManager.getPomodoroState(workspace: workspace))
                            .onAppear {
                                bottomMenuControllerSelection = .pomodoro
                            }
                    }
                    Route("workspace-timetracking") { info in
                        WorkspaceTimeTracking(timeTracker: workspace.timeTracker)
                    }
                    Route("workspace-launcher/*") {
                        WorkspaceLauncher(launcher: workspace.launcher)
                            .onAppear {
                                bottomMenuControllerSelection = .launcher
                            }
                    }
                    Route("workspace-blocker") {
                        WorkspaceBlocker()
    //                        .environmentObject(BlockerVM(realm, workspace: workspace))
                            .onAppear {
                                bottomMenuControllerSelection = .blocker
                            }
                    }
                }
                
                Spacer()
                
                Text(stateManager.selectedWorkspace!.name)

                if shouldShowInactiveBottomMenu()
                {
                    InactiveBottomMenu()
                }
                else
                {
                    BottomMenu(
                        workspace: workspace,
                        pomodoroState: stateManager.getPomodoroState(workspace: workspace),
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
        else
        {
            Text("Loading...")
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
