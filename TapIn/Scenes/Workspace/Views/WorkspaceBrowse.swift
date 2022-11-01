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
            TabView(selection: $workspace.workspaceTab) {
                WorkspacePomodoro()
                    .tabItem { Text("Pomodoro") }
                    .tag(WorkspaceTab.pomodoro)
                
                WorkspaceTimeTracking()
                    .tabItem { Text("Time Tracking") }
                    .tag(WorkspaceTab.timetracking)
                
                WorkspaceLauncher()
                    .tabItem({ Text("Launcher") })
                    .tag(WorkspaceTab.launcher)
                
                WorkspaceBlocker()
                    .tabItem({ Text("Blocker") })
                    .tag(WorkspaceTab.blocker)
                
                RadioView()
                    .tabItem({ Text("Radio") })
                    .tag(WorkspaceTab.radio)
            }
            
            Spacer()
            
            BottomMenu()
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }
}
