import RealmSwift

/// This class holds a hash map of PomodoroState objects. The main method is getPomodoroState which gets an existing state
/// from the hash map or creates a new one and adds it to the hash map
/// This is necessary to be able to have a Pomodoro instance running, but still navigate to a different workspace and see a pomodoro,
/// but not be able to start it (you get an error saying "Other pomodoro already in progress"
class PomodoroStatesHolder {
    var pomodoroStates: [ObjectId: PomodoroState] = [:]

    /// Get a pomodoro state based on a workspace, either loading an existing one (most likely the
    /// actively running one) or create a pomodoro state for the passed in workspace (with the right
    /// pomodoro duration, break schedule, etc.) and store it.
    /// - Parameters:
    ///   - realm: realm instance
    ///   - ws: workspace to create new pomodoro state based on, or to find existing pomodoro state corresponding to this workspace
    /// - Returns: pomodoro state object
    func getPomodoroState(realm: Realm, ws: WorkspaceDB, stateManager: StateManager) -> PomodoroState {
        let workspaceId = ws.id
        
        if let state = pomodoroStates[workspaceId]
        {
//            state.realm = realm
            state.updateUI()
            return state
        }
        else
        {
            pomodoroStates = pomodoroStates.filter({
                $0.value.timerMode != .initial
            })
            
            let state = PomodoroState(realm: realm, ws: ws, stateManager: stateManager)
            pomodoroStates[workspaceId] = state
            
            return state
        }
    }
    
    // Might remove this
    func getActivePomodoro() -> PomodoroState? {
        let statesConsideredActivePomodoro = [TimerMode.running, TimerMode.paused]
        let active = pomodoroStates.filter({
            statesConsideredActivePomodoro.contains($0.value.timerMode)
        })
        
        assert(active.count <= 1)
        
        return active.first?.value
    }
}
