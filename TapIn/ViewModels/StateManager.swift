import SwiftUI
import Combine
import RealmSwift

class StateManager: ObservableObject {
    
    // MARK: General
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var sidebarSelection: String? = "home"
    
    /// I will remporarily use this to refresh the view, but it shouldn't be used because if your viewmodels and stuff are done correctly it's done automatically
    func refresh() {
        objectWillChange.send()
    }
    
    // MARK: Pomodoro
    
    var pomodoroStates: [ObjectId: PomodoroState] = [:]
    
    func getPomodoroState(realm: Realm, ws: WorkspaceDB) -> PomodoroState {
        let workspaceId = ws.id
        
        if let existingState = pomodoroStates[workspaceId] {
            existingState.realm = realm
            existingState.setRemainingTime()
            
            return existingState
        }
        
        pomodoroStates = pomodoroStates.filter({
            $0.value.timerMode != .initial
        })
        
        let newState = PomodoroState(realm: realm, ws: ws)
        
        pomodoroStates[workspaceId] = newState
        
        return newState
    }
    
    func getActivePomodoro() -> PomodoroState? {
        let statesConsideredActivePomodoro = [TimerMode.running, TimerMode.paused]
        let active = pomodoroStates.filter({
            statesConsideredActivePomodoro.contains($0.value.timerMode)
        })
        
        assert(active.count <= 1)
        
        if active.count == 1 {
            return active.first?.value
        }
        
        return nil
    }
    
}
