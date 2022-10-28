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

class StateManager: ObservableObject {
    
    var realm: Realm {
        RealmManager.shared.realm
    }
    
    @Published var workspaces: Results<WorkspaceDB>

//    var workspaceMenuItems: [MenuItemNode] {
//        return MenuItemNode.createOutline(workspaces: Array(workspaces))
//    }
    
    var workspaceMenuItems: [MenuItemNode] = []
    
    init() {
        let realm = RealmManager.shared.realm
        
        self.workspaces = realm.objects(WorkspaceDB.self)
        self.workspaceMenuItems = MenuItemNode.createOutline(workspaces: Array(workspaces))
    }
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    
    @Published var sidebarSelection: String? = MenuItem.home.id
    
    private let subcomponentsHolder = SubcomponentsHolder()

    func getActiveSession(workspace: WorkspaceDB) -> Subcomponents {
        let session = subcomponentsHolder.getObject(workspace: workspace, stateManager: self)

        return session
    }

    func refreshActiveWorkspace() {
        self.activeWorkspace = subcomponentsHolder.getActiveWorkspace()
    }
    
    // Unused
    func changeToWorkspace(ws: WorkspaceDB) {
//        sidebarSelection = MenuItem.workspace(ws)
    }
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    func addWorkspace() {
        try? realm.write({
            let ws = WorkspaceDB(name: "New Workspace")

            realm.add(ws)
        })
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
