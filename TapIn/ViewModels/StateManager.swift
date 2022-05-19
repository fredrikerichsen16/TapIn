import SwiftUI
import Combine
import RealmSwift

enum TimerMode {
    case initial
    case running
    case paused
}

enum PomodoroStage {
    case pomodoro(Double)
    case shortBreak(Double)
    case longBreak(Double)
    
    func getDuration() -> Double {
        switch self
        {
            case .pomodoro(let duration), .shortBreak(let duration), .longBreak(let duration):
                return duration
        }
    }
    
    func getTitle() -> String {
        switch self
        {
        case .pomodoro(_):
            return "Work Work Work!"
        case .shortBreak(_):
            return "Short Break"
        case .longBreak(_):
            return "Long Break"
        }
    }
}

class PomodoroState: ObservableObject {
    @Published var activeWorkspace: WorkspaceDB
    
    var pomodoroDb: PomodoroDB
    
    var activePomodoro: PomodoroDB? {
        activeWorkspace.pomodoro
    }
    
    // MARK: Pomodoro (put in separate observable object eventually)
    
    @Published var remainingTimeString = "00:00"
    @Published var circleProgress: Double = 1.0
    
    @Published var timerMode: TimerMode = .initial
    @Published var pomodoroStage: PomodoroStage
    
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init(ws: WorkspaceDB) {
        activeWorkspace = ws
        pomodoroDb = ws.pomodoro!
        
        pomodoroStage = .pomodoro(60.0 * 0.5) // setInitialStage()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerMode != .running { return }
            
            self.timeElapsed += 1
            self.updateUI()
            
            if self.remainingTime ?? 1 < 0 {
                self.setNextStage()

                self.updateUI()
            }
        }
    }
    
    func setNextStage() {
        timerMode = .initial

        switch pomodoroStage {
        case .pomodoro(_):
            pomodoroStage = .shortBreak(60.0 * 0.5)
        case .shortBreak(_), .longBreak(_):
            pomodoroStage = .pomodoro(60.0 * 1.0)
        }

        timeElapsed = 0
    }
    
    func updateUI() {
        self.setRemainingTime()
        self.setCircleProgress()
    }
    
    func setRemainingTime() {
        remainingTime = pomodoroStage.getDuration() - timeElapsed
        remainingTimeString = getReadableTime()
    }
    
    func setCircleProgress() {
        let duration = pomodoroStage.getDuration()
        
        self.circleProgress = (duration - timeElapsed) / duration
    }
    
    func getReadableTime() -> String {
        guard let remainingTime = remainingTime else { return "N/A" }

        
        let formatter = DateComponentsFormatter()
            formatter.allowedUnits = [.minute, .second]
            formatter.unitsStyle = .positional
            formatter.zeroFormattingBehavior = .pad
        
        return formatter.string(from: remainingTime) ?? "N/A"
    }
    
    func startSession() {
        print(["Started workspace: ", activeWorkspace.name])
        timeElapsed = 0
        timerMode = .running
        
        updateUI()
    }

    func pauseSession() {
        timerMode = .paused
        
        updateUI()
    }
    
    func resumeSession() {
        timerMode = .running
        
        updateUI()
    }

    func cancelSession() {
        timerMode = .initial
        timeElapsed = 0
        
        updateUI()
    }
    
}

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
    
    func getPomodoroState(ws: WorkspaceDB) -> PomodoroState {
        let workspaceId = ws.id
        
        if let existingState = pomodoroStates[workspaceId] {
            existingState.setRemainingTime()
            
            return existingState
        }
        
        pomodoroStates = pomodoroStates.filter({
            $0.value.timerMode != .initial
        })
        
        let newState = PomodoroState(ws: ws)
        
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
