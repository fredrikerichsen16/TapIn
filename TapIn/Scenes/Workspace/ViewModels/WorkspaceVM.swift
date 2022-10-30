import Foundation

class WorkspaceVM: ObservableObject {
    static var current: WorkspaceVM? = nil
    
    static func getCurrent(for workspace: WorkspaceDB, stateManager: StateManager) -> WorkspaceVM {
        print("BALLZ")
        if let current = current, current.workspace == workspace
        {
            return current
        }
        
        return WorkspaceVM(stateManager: stateManager, workspace: workspace)
    }
    
    var stateManager: StateManager
    var workspace: WorkspaceDB
    
    private init(stateManager: StateManager, workspace: WorkspaceDB) {
        self.stateManager = stateManager
        self.workspace = workspace
        self.pomodoroState = PomodoroState(workspaceVM: self)
        self.timeTrackerState = TimeTrackerState(workspaceVM: self)
        self.radioState = RadioState(workspaceVM: self)
    }
    
    func isActive() -> Bool {
        true //stateManager.activeWorkspace == self.workspace
    }
    
    @Published var pomodoroState: PomodoroState!
    
    @Published var timeTrackerState: TimeTrackerState!
    
    @Published var radioState: RadioState!
}

class TimeTrackerState: ObservableObject {
    private var workspaceVM: WorkspaceVM
    
    init(workspaceVM: WorkspaceVM) {
        self.workspaceVM = workspaceVM
    }
}
