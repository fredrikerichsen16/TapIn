import Foundation
import RealmSwift

class TimeTrackerState: WorkspaceComponentViewModel {
    init(workspace: WorkspaceDB) {
        super.init(workspace: workspace, realm: RealmManager.shared.realm)
        
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
    
    // MARK: Start and end session
    
    @Published var isActive = false
    
    func startSession() {
        isActive = true
        sendStatusChangeNotification(status: .running)
    }
    
    func endSession() {
        isActive = false
        sendStatusChangeNotification(status: .initial)
    }
}
