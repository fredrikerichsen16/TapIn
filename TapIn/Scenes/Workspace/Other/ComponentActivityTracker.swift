import Foundation

class ComponentActivityTracker {
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    let workspace: WorkspaceState
    
    init(workspace: WorkspaceState) {
        self.workspace = workspace
        
        // Observing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.pomodoro)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.timeTracker)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.radio)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.blocker)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var componentsStatus: [WorkspaceTab: TimerMode] = [
        .pomodoro: .initial,
        .timetracking: .initial,
        .blocker: .initial,
        .radio: .initial
    ]
    
    private func getStatusAndComponent(from notification: Notification) -> (WorkspaceTab, TimerMode)? {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return nil
        }
        
        if let component = userInfo["component"] as? WorkspaceTab,
           let status = userInfo["status"] as? TimerMode
        {
            return (component, status)
        }
        
        return nil
    }
    
    @objc func componentDidChangeStatus(_ notification: Notification) {
        guard let (component, status) = getStatusAndComponent(from: notification) else {
            return
        }
        
        componentsStatus[component] = status
        
        if componentsStatus.values.contains(where: { $0.isActive() })
        {
            coordinator.setActive(workspace: workspace)
        }
        else
        {
            coordinator.disactivate()
        }
        
        if component == .pomodoro {
            cascade(status: status)
        }
        
        printStatus()
    }
    
    // MARK: Cascading
    
    func cascade(status: TimerMode) {
        guard let folder = workspace.workspace.getFolder() else {
            return
        }
        
        var components: Set<WorkspaceTab> = Set()
        
        switch status
        {
        case .initial:
            components = Set(folder.cascadingSettings.pomodoroEndCascade)
        case .paused:
            components = Set(folder.cascadingSettings.pomodoroPauseCascade)
        case .running:
            components = Set(folder.cascadingSettings.pomodoroStartCascade)
        }
        
        switch status
        {
        case .initial, .paused:
            for component in components
            {
                switch component
                {
                case .timetracking:
                    workspace.timeTracker.endSession()
                case .blocker:
                    workspace.blocker.endSession()
                case .radio:
                    workspace.radio.endSession()
                default:
                    break
                }
            }
        case .running:
            for component in components
            {
                switch component
                {
                case .timetracking:
                    workspace.timeTracker.startSession()
                case .blocker:
                    workspace.blocker.startSession()
                case .radio:
                    workspace.radio.startSession()
                case .launcher:
                    workspace.launcher.openAll()
                default:
                    break
                }
            }
        }
    }
    
    func printStatus() {
        for (key, value) in componentsStatus
        {
            print("\(key.label): \(value)")
        }
    }
    
    func sessionIsInProgress() -> Bool {
        return componentsStatus[.pomodoro] != .initial || componentsStatus[.timetracking] == .running
    }
}
