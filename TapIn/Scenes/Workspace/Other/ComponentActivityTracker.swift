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
                                               object: workspace.radio)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.componentDidChangeStatus,
                                               object: workspace.blocker)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var componentsStatus: [WorkspaceTab: WorkspaceComponentStatus] = [
        .pomodoro: false,
        .blocker: false,
        .radio: false
    ]
    
    private func getStatusAndComponent(from notification: Notification) -> (WorkspaceTab, WorkspaceComponentStatus)? {
        guard let userInfo = notification.userInfo as? [String: Any] else {
            return nil
        }
        
        if let component = userInfo["component"] as? WorkspaceTab,
           let status = userInfo["status"] as? WorkspaceComponentStatus
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
        
        if componentsStatus.values.contains(where: { $0 == true })
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
    
    func cascade(status: WorkspaceComponentStatus) {
        let components: Set<WorkspaceTab> = UserDefaultsManager.main.cascadingOptions
        
        for component in components
        {
            switch (component, status)
            {
            case (.blocker, true):
                workspace.blocker.startSession()
            case (.blocker, false):
                workspace.blocker.endSession()
            case (.radio, true):
                workspace.radio.startSession()
            case (.radio, false):
                workspace.radio.endSession()
            case (.launcher, true):
                workspace.launcher.openAll()
            default:
                break
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
        return componentsStatus[.pomodoro] == true
    }
}
