import Foundation

class ComponentActivityTracker {
    let componentDidChangeActivityStatus: NSNotification.Name = NSNotification.Name("ComponentDidChangeActivityStatus")
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    
    let workspace: WorkspaceVM
    
    init(workspace: WorkspaceVM) {
        self.workspace = workspace
        
        // Observing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(pomodoroComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.pomodoroState)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(timeTrackerComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.timeTrackerState)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(radioComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.radioState)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(blockerComponentDidChangeStatus(_:)),
                                               name: componentDidChangeActivityStatus,
                                               object: workspace.blockerState)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var activeComponents: Set<WorkspaceTab> = Set()
    
    private func getStatus(from notification: Notification) -> TimerMode? {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return nil
        }
        
        return userInfo["status"] as? TimerMode
    }
    
    private func forNowAllOfThemHaveTheSameImplementation(notification: Notification, tab: WorkspaceTab) {
        guard let status = getStatus(from: notification) else {
            return
        }
        
        if status.isActive()
        {
            activeComponents.insert(tab)
            
            coordinator.setActive(workspace: workspace)
        }
        else
        {
            activeComponents.remove(tab)
            
            if activeComponents.isEmpty
            {
                coordinator.disactivate()
            }
        }
        
        print(activeComponents)
    }
    
    @objc func pomodoroComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .pomodoro)
    }
    
    @objc func timeTrackerComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .timetracking)
    }
    
    @objc func radioComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .radio)
    }
    
    @objc func blockerComponentDidChangeStatus(_ notification: Notification) {
        forNowAllOfThemHaveTheSameImplementation(notification: notification, tab: .blocker)
    }
}

class WorkspaceVM: ObservableObject {
    static var preview: WorkspaceVM = {
        let realm = RealmManager.preview.realm
        let workspace = realm.objects(WorkspaceDB.self).first!
        let workspaceVM = WorkspaceVM(workspace: workspace)
        
        workspaceVM.pomodoroState.realm = realm
        workspaceVM.timeTrackerState.realm = realm
        workspaceVM.radioState.realm = realm
        workspaceVM.launcherState.realm = realm
        workspaceVM.blockerState.realm = realm
        
        return workspaceVM
    }()
    
    // MARK: Init
    
    var workspace: WorkspaceDB
    var componentActivityTracker: ComponentActivityTracker!
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        self.pomodoroState = PomodoroState(workspace: workspace)
        self.timeTrackerState = TimeTrackerState(workspace: workspace)
        self.radioState = RadioState(workspace: workspace)
        self.launcherState = LauncherState(workspace: workspace)
        self.blockerState = BlockerState(workspace: workspace)
        self.componentActivityTracker = ComponentActivityTracker(workspace: self)
    }

    // MARK: Tab states
    
    let pomodoroState: PomodoroState
    let timeTrackerState: TimeTrackerState
    let radioState: RadioState
    let launcherState: LauncherState
    let blockerState: BlockerState
    
    // MARK: Tab
    
    @Published var workspaceTab: WorkspaceTab = .pomodoro {
        didSet {
            guard workspaceTab.hasBottomMenuTool()  else {
                return
            }
            
            bottomMenuTab = workspaceTab
        }
    }
    
    @Published var bottomMenuTab: WorkspaceTab = .pomodoro
    
    deinit {
        print("WorkspaceVM DID DEINITIALIZE")
    }
}
