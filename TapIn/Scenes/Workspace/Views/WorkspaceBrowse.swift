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
    }
}

struct WorkspaceBrowse: View {
    @EnvironmentObject var workspace: WorkspaceVM
    
    @State private var tabViewSelection: WorkspaceTab = .pomodoro
    
    var body: some View {    
        VStack {
            TabView(selection: $workspace.workspaceTab) {
                WorkspacePomodoro()
                    .tabItem { tabItemBuilder(tab: .pomodoro) }
                    .tag(WorkspaceTab.pomodoro)
                
                WorkspaceTimeTracking()
                    .tabItem { tabItemBuilder(tab: .timetracking) }
                    .tag(WorkspaceTab.timetracking)
                
                WorkspaceLauncher()
                    .tabItem({ tabItemBuilder(tab: .launcher) })
                    .tag(WorkspaceTab.launcher)
                
                WorkspaceBlocker()
                    .tabItem({ tabItemBuilder(tab: .blocker) })
                    .tag(WorkspaceTab.blocker)
                
                RadioView()
                    .tabItem({ tabItemBuilder(tab: .radio) })
                    .tag(WorkspaceTab.radio)
                
                NotesView(note: workspace.workspace.note)
                    .tabItem({ tabItemBuilder(tab: .notes) })
                    .tag(WorkspaceTab.notes)
            }
            
            Spacer()
            
            BottomMenu()
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }
    
    @ViewBuilder
    func tabItemBuilder(tab: WorkspaceTab) -> some View {
        Text(tab.label)
//            .fontWeight(workspace.componentActivityTracker.activeComponents.contains(tab) ? .bold : .regular)
    }
}
