import Foundation
import RealmSwift

class WorkspaceComponentViewModel: ObservableObject {
    var realm: Realm
    let workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB, realm: Realm) {
        self.workspace = workspace
        self.realm = realm
    }
    
    func sendStatusChangeNotification(status: TimerMode) {
        NotificationCenter.default.post(name: Notification.Name("ComponentDidChangeActivityStatus"), object: self, userInfo: ["status": status])
    }
}

// For now I will just use TimerMode from Pomodoro, but it might be a good idea to have a different enum.
//enum WorkspaceComponentStatus {
//    case inactive
//    case active
//    case paused
//}
