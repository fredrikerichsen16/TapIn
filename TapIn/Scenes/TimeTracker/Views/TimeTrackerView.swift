import SwiftUI
import RealmSwift

struct TimeTrackerView: View {
    @EnvironmentObject var workspace: WorkspaceState
    
    var vm: TimeTrackerState {
        workspace.timeTracker
    }
        
    var body: some View {
        VStack {
            Text("This week, you have completed \(vm.numberOfSessions) sessions and worked for \(vm.workDuration) in this workspace.").font(.title2)
            Text("Go to Statistics to see more")
            
            Text("This application tracks how many minutes you work each day broken down by category. Every time you complete a pomodoro session, the amount of time you worked is logged. Alternatively you can turn on time tracking manually.")
        }
        .onAppear {
            vm.fetch()
        }
    }
}
