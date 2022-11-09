import SwiftUI
import RealmSwift

struct WorkspaceView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var body: some View {    
        VStack {
            TabView(selection: $workspace.workspaceTab) {
                PomodoroView()
                    .tabItem { tabItemBuilder(tab: .pomodoro) }
                    .tag(WorkspaceTab.pomodoro)
                
                TimeTrackerView()
                    .tabItem { tabItemBuilder(tab: .timetracking) }
                    .tag(WorkspaceTab.timetracking)
                
                LauncherView()
                    .tabItem({ tabItemBuilder(tab: .launcher) })
                    .tag(WorkspaceTab.launcher)
                
                BlockerView()
                    .tabItem({ tabItemBuilder(tab: .blocker) })
                    .tag(WorkspaceTab.blocker)
                
                RadioView()
                    .tabItem({ tabItemBuilder(tab: .radio) })
                    .tag(WorkspaceTab.radio)
                
                NotesView(workspace: workspace.workspace)
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
