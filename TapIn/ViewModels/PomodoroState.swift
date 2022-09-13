import SwiftUI
import RealmSwift

let divideDurationBy = 1.0

class Ticker {
    let pomodoroState: PomodoroState
    
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: timerInterval)
    }
    
    private func timerInterval(timer: Timer) {
        // Make time advance if clock is running
        if pomodoroState.timerMode != .running { return }
        self.timeElapsed += 1
        
        updateUI()
        
        if self.remainingTime ?? 1 < 0 {
            pomodoroState.completedSession()
            updateUI()
        }
    }
    
    public func updateUI() {
        // Get remaining time as readable string
        let duration = self.pomodoroState.stageState.getStageDuration()
        self.remainingTime = duration - self.timeElapsed
        let readableTime = self.getReadableTime(seconds: self.remainingTime!)
        
        // Get circle progress
        let circleProgress = self.getCircleProgress(duration: duration, timeElapsed: self.timeElapsed)
        
        pomodoroState.updateUI(readableTime: readableTime, circleProgress: circleProgress)
    }
    
    private func getReadableTime(seconds: Double) -> String {
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: seconds) ?? "N/A"
    }
    
    private func getCircleProgress(duration: Double, timeElapsed: Double) -> Double {
        return (duration - timeElapsed) / duration
    }
    
    func resetTimer() {
        timeElapsed = 0
        timer.fire()
    }
}

class PomodoroState: ObservableObject {
    @Published var workspace: WorkspaceDB
    
    var pomodoroDb: PomodoroDB
    var realm: Realm
    
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
        }
    }
    
    var ticker: Ticker!
    
    // Pomodoro Timer States
    var timerState: PomodoroTimerState!
    var initialTimerState: PomodoroTimerState!
    var runningTimerState: PomodoroTimerState!
    var pausedTimerState: PomodoroTimerState!
    
    var stageState: PomodoroStageState!
    var workingStageState: PomodoroStageState!
    var shortBreakStageState: PomodoroStageState!
    var longBreakStageState: PomodoroStageState!
    
    init(realm: Realm, ws: WorkspaceDB) {
        self.workspace = ws
        self.pomodoroDb = ws.pomodoro!
        self.realm = realm
//        self.pomodoroStage = .pomodoro(pomodoroDb.pomodoroDuration / divideDurationBy) // setInitialStage()
        
        self.initialTimerState = PomodoroInitialTimerState(self)
        self.runningTimerState = PomodoroRunningTimerState(self)
        self.pausedTimerState = PomodoroPausedTimerState(self)
        self.timerState = initialTimerState
        
        self.workingStageState = PomodoroWorkingStageState(self, duration: self.pomodoroDb.pomodoroDuration)
        self.shortBreakStageState = PomodoroShortBreakStageState(self, duration: self.pomodoroDb.shortBreakDuration)
        self.longBreakStageState = PomodoroLongBreakStageState(self, duration: self.pomodoroDb.longBreakDuration)
        self.stageState = workingStageState
        
        self.ticker = Ticker(self)
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
    
    func completedSession() {
        let (thawed, realm) = workspace.easyThaw()
        var numCompletedSessions: Int = 0
        
        let pomodoroStageEnum = stageState.getStageEnumRealm()
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

// POMODORO TIMER STATES

protocol PomodoroTimerState {
    var pomodoroState: PomodoroState { get set }
    
    init(_ pomodoroState: PomodoroState)
    func start()
    func pause()
    func cancel()
    func getButtons(stage: PomodoroStage) -> AnyView
}

class PomodoroInitialTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    required init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
    }
    
    func start() {
        // TODO: Implement it like startPomodoroWithCheck()
        pomodoroState.setTimerState(.running)
    }
    
//    func startPomodoroWithCheck() {
//        if stateManager.getActivePomodoro() != nil {
//            displayCannotStartPomodoroError = true
//            return
//        }
//
//        pomodoroState.startSession()
//    }
    
    func pause() {
        fatalError("Should not be possible")
    }
    
    func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.setTimerState(.initial)
        }
        else
        {
            fatalError("Should not be possible")
        }
    }
    
    func getButtons(stage: PomodoroStage) -> AnyView {
        if stage.isInBreak()
        {
            return AnyView(HStack {
                Button("Skip", action: pomodoroState.cancelSession)
                Button("Start", action: pomodoroState.startSession)
            })
        }
        else
        {
            return AnyView(HStack {
                Button("Start", action: pomodoroState.startSession)
                Button("", action: {})
            })
        }
    }
}

class PomodoroRunningTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    required init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
    }
    
    func start() {
        fatalError("Should not be possible")
    }
    
    func pause() {
        pomodoroState.setTimerState(.paused)
    }
    
    func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.completedSession()
        }
        else
        {
            pomodoroState.setTimerState(.initial)
        }
    }
    
    func getButtons(stage: PomodoroStage) -> AnyView {
        if stage.isInBreak()
        {
            return AnyView(HStack {
                Button("Skip", action: pomodoroState.cancelSession)
                Button("Pause", action: pomodoroState.pauseSession)
            })
        }
        else
        {
            return AnyView(HStack {
                Button("Cancel", action: pomodoroState.cancelSession)
                Button("Pause", action: pomodoroState.pauseSession)
            })
        }
    }
}

class PomodoroPausedTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    required init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
    }
    
    func start() {
        pomodoroState.setTimerState(.running)
    }
    
    func pause() {
        fatalError("Should not be possible")
    }
    
    func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.completedSession()
        }
        else
        {
            pomodoroState.setTimerState(.initial)
        }
    }
    
    func getButtons(stage: PomodoroStage) -> AnyView {
        if stage.isInBreak()
        {
            return AnyView(HStack {
                Button("Skip", action: pomodoroState.cancelSession)
                Button("Resume", action: pomodoroState.startSession)
            })
        }
        else
        {
            return AnyView(HStack {
                Button("Cancel", action: pomodoroState.cancelSession)
                Button("Resume", action: pomodoroState.startSession)
            })
        }
    }
}

// POMODORO STAGE STATES

protocol PomodoroStageState {
    var pomodoroState: PomodoroState { get set }
    var stage: PomodoroStage { get set }
    
    init(_ pomodoroState: PomodoroState, duration: Double)
    
    func transitionToNextState()
    func getLabel() -> String
    
    func getStageDuration() -> Double
    func isInBreak() -> Bool
}

extension PomodoroStageState {
    func getStageEnumRealm() -> PomodoroStageRealm {
        return stage.convertToRealmType()
    }
    
    func isInBreak() -> Bool {
        return stage.isInBreak()
    }
    
    func getStageDuration() -> Double {
        return self.stage.getDuration()
    }
}

final class PomodoroWorkingStageState: PomodoroStageState {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage
    
    init(_ pomodoroState: PomodoroState, duration: Double) {
        self.pomodoroState = pomodoroState
        self.stage = .pomodoro(duration)
    }
    
    func transitionToNextState() {
        let numCompletedSessions = pomodoroState.workspace.numSessionsCompletedToday()
        let longBreakFrequency = Int(pomodoroState.pomodoroDb.longBreakFrequency)
        
        if numCompletedSessions % longBreakFrequency == 0
        {
            pomodoroState.setStageState(pomodoroState.longBreakStageState)
        }
        else
        {
            pomodoroState.setStageState(pomodoroState.shortBreakStageState)
        }
    }
    
    func getLabel() -> String {
        return "Work Work Work!"
    }
}

final class PomodoroShortBreakStageState: PomodoroStageState {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage
    
    init(_ pomodoroState: PomodoroState, duration: Double) {
        self.pomodoroState = pomodoroState
        self.stage = .shortBreak(duration)
    }
    
    func transitionToNextState() {
        pomodoroState.setStageState(pomodoroState.workingStageState)
    }
    
    func getLabel() -> String {
        return "Short Break"
    }
}

final class PomodoroLongBreakStageState: PomodoroStageState {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage
    
    init(_ pomodoroState: PomodoroState, duration: Double) {
        self.pomodoroState = pomodoroState
        self.stage = .longBreak(duration)
    }
    
    func transitionToNextState() {
        pomodoroState.setStageState(pomodoroState.workingStageState)
    }
    
    func getLabel() -> String {
        return "Long Break"
    }
}
