import SwiftUI
import SwiftUIRouter
import RealmSwift



struct WorkspaceBrowse: View {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
//    @EnvironmentObject var workspaceVM: WorkspaceVM
//    @EnvironmentObject var sidebarVM: SidebarVM
    
//    @State var bottomMenuControllerSelection = BottomMenuControllerSelection.pomodoro
    
    @State var selection = Route.pomodoro
    @State private var path = [Route]()
  
//    var body: some View {
//        VStack {
//            HStack(alignment: .center) {
//                Picker("", selection: $selection) {
//                    Text("Pomodoro").tag(Route.pomodoro)
//                    Text("Time Tracking").tag(Route.timetracker)
//                    Text("Launcher").tag(Route.launcher)
//                    Text("Blocker").tag(Route.blocker)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                .frame(width: 400)
//                .onChange(of: selection, perform: { selection in
//                    path = [selection]
//                })
//            }
//            
//            NavigationStack(path: $path) {
//                EmptyView()
//                    .navigationDestination(for: Route.self, destination: { route in
//                        switch route
//                        {
//                        case .pomodoro:
//                            Text("POMODORO")
//                        case .launcher:
//                            Text("Launcher")
//                        default:
//                            Text("Balls")
//                        }
//                    })
//            }
//        }
//    }
    
//    var body: some View {
//
//        TabView {
//            Text("Pomodoro").font(.largeTitle).foregroundColor(.blue)
//                .tabItem({
//                    Text("Pomodoro")
//                })
//            Text("Time Tracking").font(.largeTitle).foregroundColor(.blue)
//                .tabItem({
//                    Text("Time Tracking")
//                })
//            Text("Launcher").font(.largeTitle).foregroundColor(.blue)
//                .tabItem({
//                    Text("Launcher")
//                })
//        }
//
//    }
    
//    var body: some View {
//        VStack {
//            NavigationStack {
//                HStack(alignment: .center) {
//                    List(selection: $selection) {
//                        NavigationLink("Pomodoro", value: Route.pomodoro)
//                        NavigationLink("Time Tracking", value: Route.timetracker)
//                        NavigationLink("Launcher", value: Route.launcher)
//                        NavigationLink("Blocker", value: Route.blocker)
//            //                Image(systemName: "ellipsis")
//                    }
////                    .pickerStyle(SegmentedPickerStyle())
//                    .frame(width: 400)
//                }
//                .navigationDestination(for: Route.self, destination: { route in
//                    switch route
//                    {
//                    case .pomodoro:
//                        Text("POMODORO")
//                    case .timetracker:
//                        Text("TIME TRACKER")
//                    case .launcher:
//                        Text("LAUNCHER")
//                    case .blocker:
//                        Text("BLOCKER")
//                    default:
//                        EmptyView()
//                    }
//                })
//
//                Spacer()
//            }
//
//
//        }
//    }
    
//    var body: some View {
//        VStack {
//            SectionPicker()
//
//            Spacer()
//
//            SwitchRoutes {
//                Route("workspace-pomodoro") {
//                    WorkspacePomodoro(workspaceVM)
//                        .onAppear {
//                            bottomMenuControllerSelection = .pomodoro
//                        }
//                }
//                Route("workspace-timetracking") { info in
//                    WorkspaceTimeTracking(workspaceVM)
//                }
////                Route("workspace-launcher/*") {
////                    WorkspaceLauncher()
////                        .onAppear {
////                            bottomMenuControllerSelection = .launcher
////                        }
////                }
////                Route("workspace-blocker") {
////                    WorkspaceBlocker()
////                        .onAppear {
////                            bottomMenuControllerSelection = .blocker
////                        }
////                }
//            }
//
//            Spacer()
//
//            Text(workspaceVM.workspace.name)
//
//            BottomMenu(workspaceVM, bottomMenuControllerSelection: $bottomMenuControllerSelection)
//
////            if workspaceVM.isActive
////            {
////                BottomMenu(
////                    bottomMenuControllerSelection: $bottomMenuControllerSelection
////                )
////            }
////            else
////            {
////                InactiveBottomMenu()
////            }
//        }
//        .edgesIgnoringSafeArea([.bottom, .horizontal])
//        .onAppear {
//            navigator.navigate("/workspace-pomodoro")
//        }
//    }
    
//    func shouldShowInactiveBottomMenu() -> Bool {
//        return stateManager.activeWorkspace != nil && stateManager.activeWorkspace != workspace
//    }
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
