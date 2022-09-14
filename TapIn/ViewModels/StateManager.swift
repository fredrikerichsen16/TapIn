import SwiftUI
import Combine
import RealmSwift
import AVKit

class StateManager: ObservableObject {
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    @Published var sidebarSelection: String? = "home"
    
//    func refreshActiveWorkspace() {
//        self.activeWorkspace = getActiveWorkspace()
//    }
//
//    private func getActiveWorkspace() -> WorkspaceDB? {
//        let activePomodoro: WorkspaceDB? = pomodoroStateObjects.getActiveObject()?.workspace
//        let activeRadio: WorkspaceDB? = radioStateObjects.getActiveObject()?.workspace
//
//        // Check that they are all the same
//        let all = [activePomodoro, activeRadio].filter { $0 != nil } as! [WorkspaceDB]
//        if all.count == 0 { return nil }
//        if all.allSatisfy({ $0 == all.first }) { return nil }
//
//        return activePomodoro
//    }
    
    func changeToWorkspace(ws: WorkspaceDB) {
        sidebarSelection = MenuItem.workspace(ws).id
    }
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Pomodoro
    
    private let pomodoroStateObjects = MultiStateObjectHolder<PomodoroState>()
    
    func getPomodoroState(realm: Realm, workspace: WorkspaceDB) -> PomodoroState {
        let pomodoroState = pomodoroStateObjects.getObject(realm: realm, workspace: workspace, stateManager: self)
            pomodoroState.updateUI() // update UI once to get correct starting time duration e.g. "25:00" instead of "00:00"
        
        return pomodoroState
    }
    
    // MARK: Music Player
    
    private let radioStateObjects = MultiStateObjectHolder<RadioState>()
    
    func getRadioState(realm: Realm, workspace: WorkspaceDB) -> RadioState {
        return radioStateObjects.getObject(realm: realm, workspace: workspace, stateManager: self)
    }
}
