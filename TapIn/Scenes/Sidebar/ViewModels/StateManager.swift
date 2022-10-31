import SwiftUI
import Combine
import RealmSwift
import AVKit

class Subcomponents {
    let pomodoro: PomodoroState
    let timeTrackerState: TimeTrackerState
    let launcherState: LauncherState
    let blockerState: BlockerState
    let radio: RadioState
    
    func isActive() -> Bool {
        return pomodoro.isActive()
    }
    
    func getPomodoro() -> PomodoroState {
        return pomodoro
    }
    
    func getTimeTracker() -> TimeTrackerState {
        return timeTrackerState
    }
    
    func getLauncher() -> LauncherState {
        return launcherState
    }
    
    func getBlocker() -> BlockerState {
        return blockerState
    }
    
    func getRadio() -> RadioState {
        return radio
    }
    
    init(workspace: WorkspaceDB, stateManager: StateManager) {
        self.pomodoro = PomodoroState(workspace: workspace, stateManager: stateManager)
        self.timeTrackerState = TimeTrackerState(workspace: workspace, stateManager: stateManager)
        self.launcherState = LauncherState(workspace: workspace, stateManager: stateManager)
        self.blockerState = BlockerState(workspace: workspace, stateManager: stateManager)
        self.radio = RadioState(workspace: workspace, stateManager: stateManager)
    }
}

class SubcomponentsHolder {
    var subcomponents: [ObjectId: Subcomponents] = [:]
    
    func getObject(workspace: WorkspaceDB, stateManager: StateManager) -> Subcomponents {
        let workspaceId = workspace.id
        
        if let subcomponent = subcomponents[workspaceId]
        {
            return subcomponent
        }
        else
        {
            subcomponents = subcomponents.filter({
                $0.value.isActive()
            })
            
            let subcomponent = Subcomponents(workspace: workspace, stateManager: stateManager)
            subcomponents[workspaceId] = subcomponent
            
            return subcomponent
        }
    }
    
    func getActiveWorkspace() -> WorkspaceDB? {
        for session in subcomponents.values
        {
            if session.isActive()
            {
                return session.pomodoro.workspace
            }
        }
        
        return nil
    }
}

class StateManager: ObservableObject {
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        self.workspaces = realm.objects(WorkspaceDB.self)
        self.updateWorkspaceMenuItems()
        self.setToken()
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil

    func refreshActiveWorkspace() {
//        self.activeWorkspace = subcomponentsHolder.getActiveWorkspace()
    }
    
    // Unused
    func changeToWorkspace(ws: WorkspaceDB) {}
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Sidebar
    
    @Published var workspaces: Results<WorkspaceDB>
    
    @Published var workspaceMenuItems: [MenuItemNode] = []
    
    @Published var sidebarSelection: String? = MenuItem.home.id
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = workspaces.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: _):
                if deletions.count + insertions.count > 0 {
                    objectWillChange.send()
                    self.updateWorkspaceMenuItems()
                }
            default:
                break
            }
        })
    }
    
    func updateWorkspaceMenuItems() {
        let workspaces = Array(workspaces.filter({ $0.parent.isEmpty }))
        
        self.workspaceMenuItems = MenuItemNode.createOutline(workspaces: workspaces)
    }
    
    // MARK: Components
    
    private let subcomponentsHolder = SubcomponentsHolder()
    
    func getActiveSession(workspace: WorkspaceDB) -> Subcomponents {
        return subcomponentsHolder.getObject(workspace: workspace, stateManager: self)
    }
    
    // MARK: Pomodoro

    func getPomodoroState(workspace: WorkspaceDB) -> PomodoroState {
        let pomodoroState = getActiveSession(workspace: workspace).getPomodoro()
            pomodoroState.updateUI() // update UI once to get correct starting time duration e.g. "25:00" instead of "00:00"

        return pomodoroState
    }
    
    // MARK: Time Tracker
    
    func getTimeTrackerState(workspace: WorkspaceDB) -> TimeTrackerState {
        return getActiveSession(workspace: workspace).getTimeTracker()
    }
    
    // MARK: Launcher
    
    func getLauncherState(workspace: WorkspaceDB) -> LauncherState {
        return getActiveSession(workspace: workspace).getLauncher()
    }
    
    // MARK: Blocker
    
    func getBlockerState(workspace: WorkspaceDB) -> BlockerState {
        return getActiveSession(workspace: workspace).getBlocker()
    }

    // MARK: Music Player

    func getRadioState(workspace: WorkspaceDB) -> RadioState {
        return getActiveSession(workspace: workspace).getRadio()
    }
    
}
