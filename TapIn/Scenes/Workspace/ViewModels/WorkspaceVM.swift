import Foundation

class WorkspaceVM: ObservableObject {
    static var current: WorkspaceVM? = nil
    
    static func getCurrent(for workspace: WorkspaceDB, stateManager: StateManager) -> WorkspaceVM {
        stateManager.selectedWorkspace = workspace
        
        if let current = current, current.workspace == workspace
        {
            return current
        }
        
        return WorkspaceVM(stateManager: stateManager, workspace: workspace)
    }
    
    private var stateManager: StateManager
    var workspace: WorkspaceDB
    var isActive = false
    
    private init(stateManager: StateManager, workspace: WorkspaceDB) {
        self.stateManager = stateManager
        self.workspace = workspace
        self.pomodoroState = PomodoroState(workspaceVM: self)
        self.timeTrackerState = TimeTrackerState(workspaceVM: self)
//        self.radioState = RadioState(workspaceVM: self)
    }
    
    func startSession() {
        self.isActive = true
        WorkspaceVM.current = self
    }
    
    func endSession() {
        self.isActive = false
        WorkspaceVM.current = nil
    }
    
    var pomodoroState: PomodoroState!

    var timeTrackerState: TimeTrackerState!

//    var radioState: RadioState!
}

class TimeTrackerState: ObservableObject {
    private var workspaceVM: WorkspaceVM
    
    init(workspaceVM: WorkspaceVM) {
        self.workspaceVM = workspaceVM
    }
}
