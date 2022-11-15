import Foundation
import RealmSwift

class WorkspaceComponentViewModel: ObservableObject {
    var realm: Realm
    let workspace: WorkspaceDB
    let tab: WorkspaceTab
    
    init(workspace: WorkspaceDB, realm: Realm, tab: WorkspaceTab) {
        self.workspace = workspace
        self.realm = realm
        self.tab = tab
    }
    
    // MARK: Start and end session
    
    func sendStatusChangeNotification(status: TimerMode) {
        NotificationCenter.default.post(name: Notification.Name.componentDidChangeStatus, object: self, userInfo: ["status": status, "component": tab])
    }
    
    @Published var isActive = false
    
    func startSession() {
        guard !isActive else {
            return
        }
        
        isActive = true
        sendStatusChangeNotification(status: .running)
    }
    
    func endSession() {
        guard isActive else {
            return
        }
        
        isActive = false
        sendStatusChangeNotification(status: .initial)
    }
}

// For now I will just use TimerMode from Pomodoro, but it might be a good idea to have a different enum.
//enum WorkspaceComponentStatus {
//    case inactive
//    case active
//    case paused
//}
