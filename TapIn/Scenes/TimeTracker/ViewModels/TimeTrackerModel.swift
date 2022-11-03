import Foundation
import RealmSwift

class TimeTrackerState: ObservableObject {
    var realm: Realm
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.realm = RealmManager.shared.realm
        
        setContent()
    }
    
    func setContent() {
        // Query
        let queryer = SessionHistoryQueryer()
            queryer.completedThisWeek()
            queryer.inWorkspace(workspace: workspace)
        
        // Get Results
        let numSessions = queryer.getNumSessionsCompleted()
        let workDuration = queryer.getWorkDurationFormatted()
        
        self.numberOfSessions = numSessions
        self.workDuration = workDuration
    }
    
    @Published var numberOfSessions = 0
    @Published var workDuration = "? hours"
}
