import Foundation

class WorkspaceVM: ObservableObject {
    var stateManager: StateManager
    var workspace: WorkspaceDB
    
    init(stateManager: StateManager, workspace: WorkspaceDB) {
        self.stateManager = stateManager
        self.workspace = workspace
    }
}
