import Foundation

class WorkspaceVM: ObservableObject {
    // MARK: Static
    
//    static var preview: WorkspaceVM = WorkspaceVM(workspace: WorkspaceDB(name: "Workspace"))
    
    static var current: WorkspaceVM? = nil

    static func getCurrent(for workspace: WorkspaceDB) -> WorkspaceVM {
        if let current = current, current.workspace == workspace
        {
            return current
        }

        return WorkspaceVM(workspace: workspace)
    }
    
    static func shouldShowActiveBottomMenu(for workspace: WorkspaceDB) -> Bool {
        if let current = WorkspaceVM.current
        {
            return current.workspace == workspace
        }
        
        return true
    }

    // MARK: Init
    
    var workspace: WorkspaceDB
    
    private init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.pomodoroState = PomodoroState(workspace: workspace)
        self.timeTrackerState = TimeTrackerState(workspace: workspace)
        self.radioState = RadioState(workspace: workspace)
        self.launcherState = LauncherState(workspace: workspace)
        self.blockerState = BlockerState(workspace: workspace)
    }
    
    var isActive = false

    func startSession() {
        self.isActive = true
        WorkspaceVM.current = self
    }

    func endSession() {
        self.isActive = false
        WorkspaceVM.current = nil
    }

    // MARK: Tab states
    
    var pomodoroState: PomodoroState!
    var timeTrackerState: TimeTrackerState!
    var radioState: RadioState!
    var launcherState: LauncherState!
    var blockerState: BlockerState!
    
    // MARK: Tab
    
    @Published var workspaceTab: WorkspaceTab = .pomodoro
    
}
