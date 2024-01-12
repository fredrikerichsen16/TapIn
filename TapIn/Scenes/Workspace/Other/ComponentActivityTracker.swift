import Foundation

protocol ComponentStatus {
    var component: WorkspaceTab { get set }
    var status: TimerMode { get set }
    var cascades: Bool { get set }
}

class PomodoroActivityStatus: ComponentStatus {
    var component = WorkspaceTab.pomodoro
    var status = TimerMode.initial
    var cascades = false
}

class BlockerActivityStatus: ComponentStatus {
    var component = WorkspaceTab.blocker
    var status = TimerMode.initial
    var cascades = false
}

class RadioActivityStatus: ComponentStatus {
    var component = WorkspaceTab.radio
    var status = TimerMode.initial
    var cascades = false
}

class ComponentsStatus {
    var componentsStatus: [WorkspaceTab: ComponentStatus] = [
        .pomodoro: PomodoroActivityStatus(),
        .blocker: BlockerActivityStatus(),
        .radio: RadioActivityStatus()
    ]
    
    func set(component: WorkspaceTab, status: TimerMode) {
        componentsStatus[component]?.status = status
    }
    
    func set(component: WorkspaceTab, cascades: Bool) {
        componentsStatus[component]?.cascades = cascades
    }
    
    func anyActive() -> Bool {
        return componentsStatus.values.contains(where: { $0.status == .running })
    }
    
    func isActive(_ component: WorkspaceTab) -> Bool {
        guard let component = componentsStatus[component] else {
            return false
        }
        
        return component.status == .running
    }
    
    func printStatus() {
        for (key, value) in componentsStatus
        {
            print("\(key.label): \(value.component.rawValue)")
        }
    }
}

class ComponentActivityTracker {
    var coordinator: WorkspaceCoordinator = WorkspaceCoordinator.shared
    
    init() {
        self.componentsStatus = ComponentsStatus()
        
        // init
        let cascadingComponents = UserDefaultsManager.standard.cascadingOptions
        setCascadingWorkspaceComponents(components: cascadingComponents)
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
    
    func updateStatus(component: WorkspaceTab, activityStatus: TimerMode, cascades: Bool? = nil) {
        componentsStatus.set(component: component, status: activityStatus)
        
        guard let cascades = cascades else {
            return
        }
        
        componentsStatus.set(component: component, cascades: cascades)
        
//        if componentsStatus.anyActive() {
//            coordinator.setActive(workspace: workspace)
//        } else {
//            coordinator.disactivate()
//        }
        
        if component == .pomodoro {
            cascade()
        }
        
        printStatus()
    }
    
    // MARK: Cascading
    
    func cascade() {
        guard let pomodoroStatus = componentsStatus.componentsStatus[.pomodoro] else {
            return
        }
        
        for (component, componentStatus) in componentsStatus.componentsStatus.filter({ $0.key != .pomodoro })
        {
            if componentStatus.cascades == false || componentStatus.status == pomodoroStatus.status {
                continue
            }
            
            switch (component, pomodoroStatus.status)
            {
            case (.blocker, .initial):
                workspace.blocker.endSession()
            case (.blocker, .running):
                workspace.blocker.startSession()
            case (.radio, .initial):
                
            }
        }
        
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
    
    func setCascadingWorkspaceComponents(components: Set<WorkspaceTab>) {
        let componentsWithCascading = components
        
        UserDefaultsManager.standard.cascadingOptions = componentsWithCascading
        
        for component in componentsStatus.componentsStatus.keys
        {
            componentsStatus.set(component: component, cascades: false)
        }
        
        for component in componentsWithCascading
        {
            componentsStatus.set(component: component, cascades: true)
        }
    }
}
