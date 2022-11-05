import SwiftUI
import RealmSwift

struct WorkspaceTimeTracking: View {
    @EnvironmentObject var workspace: WorkspaceVM
        
    var body: some View {
        VStack {
            Text("This week, you have completed \(workspace.timeTracker.numberOfSessions) sessions and worked for \(workspace.timeTracker.workDuration) in this workspace.").font(.title2)
            Text("Go to Statistics to see more")
            
            Text("This application tracks how many minutes you work each day broken down by category. Every time you complete a pomodoro session, the amount of time you worked is logged. Alternatively you can turn on time tracking manually.")
        }
    }
}

//struct WorkspaceTimeTracking_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkspaceTimeTracking()
//    }
//}
