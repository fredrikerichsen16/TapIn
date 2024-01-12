import SwiftUI
import RealmSwift
import Factory

final class PomodoroState: WorkspaceComponentViewModel {
    @Published var remainingTimeString = "00:00"
    @Published var circleProgress: Double = 1.0
    @Published var timerMode: TimerMode = .initial
    @Published var buttons: [PomodoroButton] = []
    
    var ticker: PomodoroTicker!
    
    var pomodoroStadie: PomodoroStadie!
    var pomodoroStadieWorkingInitial: PomodoroStadie!
    var pomodoroStadieWorkingRunning: PomodoroStadie!
    var pomodoroStadieWorkingPaused: PomodoroStadie!
    var pomodoroStadieShortBreakInitial: PomodoroStadie!
    var pomodoroStadieShortBreakRunning: PomodoroStadie!
    var pomodoroStadieShortBreakPaused: PomodoroStadie!
    var pomodoroStadieLongBreakInitial: PomodoroStadie!
    var pomodoroStadieLongBreakRunning: PomodoroStadie!
    var pomodoroStadieLongBreakPaused: PomodoroStadie!
    
    init(workspace: WorkspaceDB, componentActivityTracker: ComponentActivityTracker) {
        let realm = Container.shared.realmManager.callAsFunction().realm
        
        super.init(workspace: workspace, realm: realm, componentActivityTracker: componentActivityTracker, component: .pomodoro)
        
        let pomodoroDb = workspace.pomodoro!
        self.pomodoroStadieWorkingInitial = PomodoroStadieWorkingInitial(self, duration: pomodoroDb.pomodoroDuration)
        self.pomodoroStadieWorkingRunning = PomodoroStadieWorkingRunning(self, duration: pomodoroDb.pomodoroDuration)
        self.pomodoroStadieWorkingPaused = PomodoroStadieWorkingPaused(self, duration: pomodoroDb.pomodoroDuration)
        self.pomodoroStadieShortBreakInitial = PomodoroStadieShortBreakInitial(self, duration: pomodoroDb.shortBreakDuration)
        self.pomodoroStadieShortBreakRunning = PomodoroStadieShortBreakRunning(self, duration: pomodoroDb.shortBreakDuration)
        self.pomodoroStadieShortBreakPaused = PomodoroStadieShortBreakPaused(self, duration: pomodoroDb.shortBreakDuration)
        self.pomodoroStadieLongBreakInitial = PomodoroStadieLongBreakInitial(self, duration: pomodoroDb.longBreakDuration)
        self.pomodoroStadieLongBreakRunning = PomodoroStadieLongBreakRunning(self, duration: pomodoroDb.longBreakDuration)
        self.pomodoroStadieLongBreakPaused = PomodoroStadieLongBreakPaused(self, duration: pomodoroDb.longBreakDuration)
        self.pomodoroStadie = pomodoroStadieWorkingInitial
        
        self.timerMode = pomodoroStadie.timerMode
        self.buttons = pomodoroStadie.getButtons()
        
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
    
    override func startSession() {
        pomodoroStadie.start()
    }
    
    func pauseSession() {
        pomodoroStadie.pause()
    }
    
    func cancelSession() {
        pomodoroStadie.cancel()
    }
    
    func setStadie(_ stadie: PomodoroStadie) {
        self.pomodoroStadie = stadie
        self.ticker.handleStadieChange(stage: stadie.stage, timerMode: stadie.timerMode)
        
        // UI update
        self.timerMode = stadie.timerMode
        self.buttons = pomodoroStadie.getButtons()
        
        // Component Activity
        let currentActiveStatus = isActive
        let newStatus = stadie.status
        
        if newStatus != currentActiveStatus
        {
            isActive = newStatus
            sendStatusChangeNotification(status: newStatus)
        }
    }

    func completedSession() {
        self.pomodoroStadie.completedSession()
    }
    
    func zapTicker() {
        self.ticker.handleStadieChange(stage: pomodoroStadie.stage, timerMode: pomodoroStadie.timerMode)
        self.ticker.updateUI()
    }
}
