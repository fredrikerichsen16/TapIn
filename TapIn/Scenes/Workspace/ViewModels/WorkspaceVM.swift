import Foundation

class WorkspaceVM: ObservableObject {
    static var current: WorkspaceVM? = nil
    
    static func getCurrent(for workspace: WorkspaceDB, stateManager: StateManager) -> WorkspaceVM {
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
        self.radioState = RadioState(workspaceVM: self)
        self.launcherState = LauncherState(workspaceVM: self)
        self.blockerModel = BlockerModel(self)
        
        print("================= INIT ===================")
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
    
    var radioState: RadioState!
    
    var launcherState: LauncherState!
    
    var blockerModel: BlockerModel!
}

class TimeTrackerState: ObservableObject {
    private var workspaceVM: WorkspaceVM
    
    init(workspaceVM: WorkspaceVM) {
        self.workspaceVM = workspaceVM
    }
    
    @Published var hoursWorked = 4
}
