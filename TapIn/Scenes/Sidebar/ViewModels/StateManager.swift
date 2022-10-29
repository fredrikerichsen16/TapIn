import SwiftUI
import Combine
import RealmSwift
import AVKit

class Subcomponents {
    let pomodoro: PomodoroState
    let radio: RadioState
    
    func isActive() -> Bool {
        return pomodoro.isActive()
    }
    
    func getPomodoro() -> PomodoroState {
        return pomodoro
    }
    
    func getRadio() -> RadioState {
        return radio
    }
    
    init(workspace: WorkspaceDB, stateManager: StateManager) {
        self.pomodoro = PomodoroState(workspace: workspace, stateManager: stateManager)
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

struct SidebarModel {
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    var workspaces: Results<WorkspaceDB>
    var menuItems: [MenuItemNode] = [] {
        didSet {
            self.menuItems = MenuItemNode.createOutline(workspaces: Array(workspaces))
        }
    }
    var selection: String? = MenuItem.home.id
    
    init(workspaces: Results<WorkspaceDB>) {
        self.workspaces = workspaces
        self.menuItems = MenuItemNode.createOutline(workspaces: Array(workspaces))
        self.selection = MenuItem.home.id
    }
}

class StateManager: ObservableObject {
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    init() {
        let realm = RealmManager.shared.realm
        
        let workspaces = realm.objects(WorkspaceDB.self)
        self.sidebarModel = SidebarModel(workspaces: workspaces)
        self.setToken()
    }
    
    var token: NotificationToken? = nil

    func setToken() {
        self.token = sidebarModel.workspaces.observe({ [unowned self] (changes) in
            switch changes
            {
            case .update(_, deletions: _, insertions: _, modifications: _):
                objectWillChange.send()
            default:
                break
            }
        })
    }
    
    @Published var sidebarModel: SidebarModel
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    
    private let subcomponentsHolder = SubcomponentsHolder()

    func getActiveSession(workspace: WorkspaceDB) -> Subcomponents {
        let session = subcomponentsHolder.getObject(workspace: workspace, stateManager: self)

        return session
    }

    func refreshActiveWorkspace() {
        self.activeWorkspace = subcomponentsHolder.getActiveWorkspace()
    }
    
    // Unused
    func changeToWorkspace(ws: WorkspaceDB) {}
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Pomodoro

    func getPomodoroState(workspace: WorkspaceDB) -> PomodoroState {
        let pomodoroState = getActiveSession(workspace: workspace).getPomodoro()
            pomodoroState.updateUI() // update UI once to get correct starting time duration e.g. "25:00" instead of "00:00"

        return pomodoroState
    }

    // MARK: Music Player

    func getRadioState(workspace: WorkspaceDB) -> RadioState {
        return getActiveSession(workspace: workspace).getRadio()
    }
    
    // MARK: New Code
    
//    var activeWorkspaceViewModel: WorkspaceVM? = nil
//
//    func getWorkspaceViewModel(workspace: WorkspaceDB) -> WorkspaceVM {
//        if activeWorkspace == workspace
//        {
//            return activeWorkspaceViewModel!
//        }
//        else
//        {
//            return WorkspaceVM(workspace: workspace, stateManager: self)
//        }
//    }
    
}
