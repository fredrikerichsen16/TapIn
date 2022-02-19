import SwiftUI
import SwiftUIRouter
import RealmSwift

struct WorkspaceBrowse: View {
    @Environment(\.realm) var realm
    @ObservedRealmObject var workspaceDB: WorkspaceDB
    
    var body: some View {
        List {
            Text("Hello!")
            Text(workspaceDB.name)
            Text(String(workspaceDB.id))
            
            if let pomodoro = workspaceDB.pomodoro {
                Text("Duration: \(pomodoro.pomodoroDuration)")
            }

            if let timer = workspaceDB.timeTracker {
                Text("Timer ID: \(timer.id)")
            }

            Button("Change") {
                guard let thawed = workspaceDB.thaw() else { return }

                try! thawed.realm!.write {
                    thawed.name = "Calculus"
                }
            }
        }
    }
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
}

//struct WorkspaceBrowse: View {
//	@State var pageSelection = "workspace-pomodoro"
//	@EnvironmentObject var navigator: Navigator
////    @ObservedRealmObject var workspace: WorkspaceDB
//
////    @EnvironmentObject var workspace: Workspace
//    @EnvironmentObject var workspaceDB: WorkspaceDB
//
//    var body: some View {
//		VStack {
//            HStack(alignment: .center) {
//				Picker("", selection: $pageSelection) {
//					Text("Pomodoro").tag("workspace-pomodoro")
//					Text("Time Tracking").tag("workspace-timetracking")
//					Text("Launcher").tag("workspace-launcher")
//					Text("Blocker").tag("workspace-blocker")
////					Image(systemName: "ellipsis")
//				}
//				.pickerStyle(SegmentedPickerStyle())
//				.onChange(of: pageSelection) { selection in
//					guard selection != "more" else { return }
//
//					navigator.navigate("/" + selection, replace: true)
//				}
//				.frame(width: 400)
//			}
//
//			SwitchRoutes {
//				Route("workspace-pomodoro") {
//                    WorkspacePomodoro()
//				}
////				Route("workspace-timetracking") { info in
////					WorkspaceTimeTracking()
////				}
////				Route("workspace-launcher/*") {
////					WorkspaceLauncher()
////				}
////				Route("workspace-blocker") {
////					WorkspaceBlocker()
////				}
//			}
//
//            Spacer()
//
//            BottomMenu()
//		}
//        .edgesIgnoringSafeArea([.bottom, .horizontal])
//		.onAppear {
//			navigator.navigate("/workspace-pomodoro")
//		}
//    }
//}
