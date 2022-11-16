import SwiftUI
import RealmSwift

struct WorkspaceView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var body: some View {    
        VStack {
            TabView(selection: $workspace.workspaceTab) {
                PomodoroView()
                    .tabItem { Text(WorkspaceTab.pomodoro.label) }
                    .tag(WorkspaceTab.pomodoro)
                
                LauncherView()
                    .tabItem({ Text(WorkspaceTab.launcher.label) })
                    .tag(WorkspaceTab.launcher)
                
                BlockerView()
                    .tabItem({ Text(WorkspaceTab.blocker.label) })
                    .tag(WorkspaceTab.blocker)
                
                RadioView()
                    .tabItem({ Text(WorkspaceTab.radio.label) })
                    .tag(WorkspaceTab.radio)
                
                NotesView(workspace: workspace.workspace)
                    .tabItem({ Text(WorkspaceTab.notes.label) })
                    .tag(WorkspaceTab.notes)
            }
            
            Spacer()
            
            BottomMenu()
        }
        .edgesIgnoringSafeArea([.bottom, .horizontal])
    }
}
