import SwiftUI
import RealmSwift

final class PomodoroState: WorkspaceComponentViewModel {
    private var pomodoroDb: PomodoroDB
        
    @Published var remainingTimeString = "00:00"
    @Published var circleProgress: Double = 1.0
    @Published var timerMode: TimerMode = .initial {
        didSet { updateActivityStatus() }
    }
    
    var ticker: PomodoroTicker!
    
    // Pomodoro Timer States
    var timerState: PomodoroTimerState!
    var initialTimerState: PomodoroTimerState!
    var runningTimerState: PomodoroTimerState!
    var pausedTimerState: PomodoroTimerState!
    
    var stageState: PomodoroStageState! {
        didSet { updateActivityStatus() }
    }
    var workingStageState: PomodoroStageState!
    var shortBreakStageState: PomodoroStageState!
    var longBreakStageState: PomodoroStageState!
    
    init(workspace: WorkspaceDB) {
        self.pomodoroDb = workspace.pomodoro
        
        super.init(workspace: workspace, realm: RealmManager.shared.realm, tab: .pomodoro)
        
        self.initialTimerState = PomodoroInitialTimerState(self)
        self.runningTimerState = PomodoroRunningTimerState(self)
        self.pausedTimerState = PomodoroPausedTimerState(self)
        self.timerState = initialTimerState
        
        self.workingStageState = PomodoroWorkingStageState(self, duration: self.pomodoroDb.pomodoroDuration)
        self.shortBreakStageState = PomodoroShortBreakStageState(self, duration: self.pomodoroDb.shortBreakDuration)
        self.longBreakStageState = PomodoroLongBreakStageState(self, duration: self.pomodoroDb.longBreakDuration)
        self.stageState = workingStageState
        
        self.ticker = PomodoroTicker(
            onUpdate: { [weak self] (readableString, circleProgress) in
                self?.remainingTimeString = readableString
                self?.circleProgress = circleProgress
            },
            onCompletedSession: { [weak self] in
                self?.completedSession()
            }
        )
        
        self.zapTicker()
    }
    
    func updateActivityStatus() {
        let newStatus = stageState.status && timerMode != .initial
        let currentStatus = isActive
        
        if newStatus != currentStatus
        {
            isActive = newStatus
            sendStatusChangeNotification(status: newStatus)
        }
    }
    
    // MARK: Pomodoro Timer States (State Pattern)
    
    override func startSession() {
        timerState.start()
    }
    
    func pauseSession() {
        timerState.pause()
    }
    
    func cancelSession() {
        timerState.cancel()
    }
    
    func getButtons() -> [PomodoroButton] {
        return self.timerState.getButtons()
    }
    
    func setTimerState(_ timerMode: TimerMode) {
        self.timerMode = timerMode
        self.ticker.running = timerMode == .running
        
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
    }
    
    // MARK: Pomodoro Stage States (State Pattern)
    
    func setStageState(_ state: PomodoroStageState) {
        self.stageState = state
        self.ticker.stageDuration = stageState.getStageDuration()
    }
    
    // MARK: ?
    
    func longBreakDue() -> Bool {
        let numCompletedSessions = workspace.numSessionsCompletedToday()
        let longBreakFrequency = Int(pomodoroDb.longBreakFrequency)
        
        return numCompletedSessions % longBreakFrequency == 0
    }
    
    func completedSession() {
        if case .working(_) = stageState.stage
        {
//            guard let workspace = workspace.thaw() else {
//                return
//            }
        
            try? realm.write {
                workspace.sessions.append(SessionDB(stage: stageState.stage))
            }
        }
        
        stageState.transitionToNextState(withNotification: true)
    }
    
    func skippedSession() {
        stageState.transitionToNextState(withNotification: false)
    }
    
    func zapTicker() {
        self.ticker.stageDuration = stageState.getStageDuration()
        self.ticker.running = timerMode == .running
        self.ticker.updateUI()
    }
    
}
