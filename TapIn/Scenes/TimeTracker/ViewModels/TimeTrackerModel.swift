import Foundation
import RealmSwift

class TimeTrackerState: ObservableObject {
    var realm: Realm
    private var workspace: WorkspaceDB
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.realm = RealmManager.shared.realm
    }
    
    @Published var hoursWorked = 4
}
