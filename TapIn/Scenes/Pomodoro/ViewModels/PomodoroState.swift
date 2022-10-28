import SwiftUI
import RealmSwift

final class PomodoroState: WorkspaceSubcomponentStateObject {
    @Published var workspace: WorkspaceDB
    internal var realm: Realm
    internal var stateManager: StateManager
    private var pomodoroDb: PomodoroDB
    
    @Published var remainingTimeString = "00:00"
    @Published var circleProgress: Double = 1.0
    
    @Published var timerMode: TimerMode = .initial {
        didSet
        {
            switch timerMode
            {
                case .initial:
                    timerState = initialTimerState
                    ticker.resetTimer()
                case .running:
                    timerState = runningTimerState
                case .paused:
                    timerState = pausedTimerState
            }
            
            stateManager.refreshActiveWorkspace()
        }
    }
    
    var ticker: PomodoroTicker!
    
    // Pomodoro Timer States
    var timerState: PomodoroTimerState!
    var initialTimerState: PomodoroTimerState!
    var runningTimerState: PomodoroTimerState!
    var pausedTimerState: PomodoroTimerState!
    
    var stageState: PomodoroStageState!
    var workingStageState: PomodoroStageState!
    var shortBreakStageState: PomodoroStageState!
    var longBreakStageState: PomodoroStageState!
    
    init(realm: Realm, workspace: WorkspaceDB, stateManager: StateManager) {
        self.workspace = workspace
        self.pomodoroDb = workspace.pomodoro!
        self.realm = realm
        self.stateManager = stateManager
        
        self.initialTimerState = PomodoroInitialTimerState(self)
        self.runningTimerState = PomodoroRunningTimerState(self)
        self.pausedTimerState = PomodoroPausedTimerState(self)
        self.timerState = initialTimerState
        
        self.workingStageState = PomodoroWorkingStageState(self, duration: self.pomodoroDb.pomodoroDuration)
        self.shortBreakStageState = PomodoroShortBreakStageState(self, duration: self.pomodoroDb.shortBreakDuration)
        self.longBreakStageState = PomodoroLongBreakStageState(self, duration: self.pomodoroDb.longBreakDuration)
        self.stageState = workingStageState
        
        self.ticker = PomodoroTicker(self)
    }
    
    func isActive() -> Bool {
        return timerMode != .initial
    }
    
    // MARK: Pomodoro Timer States (State Pattern)
    
    func startSession() {
        timerState.start()
        updateUI()
    }
    
    func pauseSession() {
        timerState.pause()
        updateUI()
    }
    
    func cancelSession() {
        timerState.cancel()
        updateUI()
    }
    
    func getButtons() -> some View {
        return self.timerState.getButtons(stage: stageState.stage)
    }
    
    func setTimerState(_ timerMode: TimerMode) {
        self.timerMode = timerMode
    }
    
    // MARK: Pomodoro Stage States (State Pattern)
    
    func setStageState(_ state: PomodoroStageState) {
        self.stageState = state
    }
    
    // MARK: ?
    
    func longBreakDue() -> Bool {
        let numCompletedSessions = workspace.numSessionsCompletedToday()
        let longBreakFrequency = Int(pomodoroDb.longBreakFrequency)
        
        return numCompletedSessions % longBreakFrequency == 0
    }
    
    func completedSession() {
        let (thawed, realm) = workspace.easyThaw()
        var numCompletedSessions: Int = 0
        
        let pomodoroStageEnum = stageState.stage
        let pomodoroStageDuration = stageState.getStageDuration()
    
        try! realm.write {
            thawed.sessions.append(SessionDB(stage: pomodoroStageEnum, duration: pomodoroStageDuration))
            numCompletedSessions = thawed.sessions.count
        }
        
        print("Have completed this many sessions: ")
        print(numCompletedSessions)
        
        print("PRINT INFO")
        for session in thawed.sessions {
            print(session.description)
        }
        
        timerMode = .initial
        
        stageState.transitionToNextState()

        ticker.resetTimer()
    }
    
    func updateUI() {
        ticker.updateUI()
    }
    
    func updateUI(readableTime: String, circleProgress: Double) {
        self.remainingTimeString = readableTime
        self.circleProgress = circleProgress
    }
    
}
