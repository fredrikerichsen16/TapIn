import Foundation

class ComponentsStatus {
    var componentsStatus: [WorkspaceTab: WorkspaceComponentStatus] = [
        .pomodoro: false,
        .blocker: false,
        .radio: false
    ]
    
    func set(component: WorkspaceTab, status: WorkspaceComponentStatus) {
        componentsStatus[component] = status
    }
    
    func anyActive() -> Bool {
        return componentsStatus.values.contains(where: { $0 == true })
    }
    
    func isActive(_ component: WorkspaceTab) -> Bool {
        return componentsStatus[component] ?? false
    }
    
    func printStatus() {
        for (key, value) in componentsStatus
        {
            print("\(key.label): \(value)")
        }
    }
}

class ComponentActivityTracker {
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    let workspace: WorkspaceState
    
    init(workspace: WorkspaceState, componentsStatus: ComponentsStatus) {
        self.workspace = workspace
        self.componentsStatus = componentsStatus
        
        // Observing
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.ComponentDidChangeStatus,
                                               object: workspace.pomodoro)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.ComponentDidChangeStatus,
                                               object: workspace.radio)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(componentDidChangeStatus(_:)),
                                               name: NSNotification.Name.ComponentDidChangeStatus,
                                               object: workspace.blocker)
    }
    
    // MARK: Keeping Track of which workspaces are active and doing cascading launch
    
    var componentsStatus: ComponentsStatus
    
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
        
        componentsStatus.set(component: component, status: status)
        
        if componentsStatus.anyActive() {
            coordinator.setActive(workspace: workspace)
        } else {
            coordinator.disactivate()
        }
        
        if component == .pomodoro {
            cascade(status: status)
        }
        
        printStatus()
    }
    
    // MARK: Cascading
    
    func cascade(status: WorkspaceComponentStatus) {
        let components: Set<WorkspaceTab> = UserDefaultsManager.standard.cascadingOptions
        
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
        componentsStatus.printStatus()
    }
    
    func sessionIsInProgress() -> Bool {
        return componentsStatus.isActive(.pomodoro)
    }
}
