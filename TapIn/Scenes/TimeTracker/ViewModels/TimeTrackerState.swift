import Foundation
import RealmSwift

class TimeTrackerState: WorkspaceComponentViewModel {
    init(workspace: WorkspaceDB) {
        super.init(workspace: workspace, realm: RealmManager.shared.realm, tab: .timetracking)
    }
    
    // MARK: UI

    /// this method runs .onAppear
    func fetch() {
        let frozen = realm.freeze()
        guard let workspaceInFrozenRealm = frozen.objects(WorkspaceDB.self).first(where: { $0.id == workspace.id }) else {
            return
        }
        
        Task {
            // Query
            let queryer = SessionHistoryQueryer(realm: frozen)
                queryer.completedThisWeek()
              queryer.inWorkspace(workspace: workspaceInFrozenRealm)
            
            // Get Results
            let numSessions = queryer.getNumSessionsCompleted()
            let workDuration = queryer.getWorkDurationFormatted()
            
            DispatchQueue.main.async {
                self.numberOfSessions = numSessions
                self.workDuration = workDuration
            }
        }
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
