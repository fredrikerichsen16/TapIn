import SwiftUI
import RealmSwift

struct WorkspaceBrowseIntermediate: View {
    @EnvironmentObject var workspace: WorkspaceVM
    @EnvironmentObject var sidebar: SidebarVM
    
    var body: some View {
        WorkspaceBrowse()
            .environmentObject(workspace.pomodoroState)
            .environmentObject(workspace.timeTrackerState)
            .environmentObject(workspace.launcherState)
            .environmentObject(workspace.blockerState)
            .environmentObject(workspace.radioState)
            .onAppear(perform: {
                sidebar.onNavigation(to: workspace.workspace)
            })
    }
}

struct WorkspaceBrowse: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    var body: some View {
        VStack {
            TabView {
                WorkspacePomodoro()
                    .tabItem { Text("Pomodoro") }
                    .onAppear {
                        workspace.workspaceTab = .pomodoro
                    }
                
                WorkspaceTimeTracking()
                    .tabItem { Text("Time Tracking") }
                    .onAppear {
                        workspace.workspaceTab = .timetracking
                    }
                
                WorkspaceLauncher()
                    .tabItem({ Text("Launcher") })
                    .onAppear {
                        workspace.workspaceTab = .launcher
                    }
                
                WorkspaceBlocker()
                    .tabItem({ Text("Blocker") })
                    .onAppear {
                        workspace.workspaceTab = .blocker
                    }
                
                RadioView()
                    .tabItem({ Text("Radio") })
                    .onAppear {
                        workspace.workspaceTab = .radio
                    }
            }
            
            Spacer()
            
            BottomMenu()
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }
}
