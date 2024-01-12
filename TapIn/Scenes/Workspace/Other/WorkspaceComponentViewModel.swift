import Foundation
import RealmSwift

class WorkspaceComponentViewModel: ObservableObject {
    var realm: Realm
    let workspace: WorkspaceDB
    let component: WorkspaceTab
    let componentActivityTracker: ComponentActivityTracker
    
    init(workspace: WorkspaceDB, realm: Realm, componentActivityTracker: ComponentActivityTracker, component: WorkspaceTab) {
        self.workspace = workspace
        self.realm = realm
        self.componentActivityTracker = componentActivityTracker
        self.component = component
    }
    
    // MARK: Start and end session
    
    @Published var isActive = false
    
    func startSession() {
        guard !isActive else {
            return
        }
        
        isActive = true
        
        componentActivityTracker.updateStatus(component: component, activityStatus: .running)
    }
    
    func endSession() {
        guard isActive else {
            return
        }
        isActive = false
        
        componentActivityTracker.updateStatus(component: component, activityStatus: .initial)
    }
}
