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
}

class StateManager: ObservableObject {
    
    var pomodoroStates: [ObjectId: StateManager] = [:]
    
    @Published var selectedWorkspace: WorkspaceDB? = nil
    @Published var activeWorkspace: WorkspaceDB? = nil
    
    var activePomodoro: PomodoroDB? {
        activeWorkspace?.pomodoro
    }
    
    @Published var sidebarSelection: String? = "home"
    
    // MARK: Pomodoro (put in separate observable object eventually)
    
    @Published var remainingTimeString = "Initial"
    @Published var circleProgress: Double = 1.0
    
    @Published var activeElsewhere: Bool = false
    
    private var timerMode: TimerMode = .initial
    private var pomodoroStage: PomodoroStage
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init() {
        pomodoroStage = .pomodoro(60.0 * 0.5)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.activeElsewhere = self.showInitialPomodoroState() != nil
            
            if self.timerMode != .running { return }
            
            self.timeElapsed += 1
            self.setRemainingTime()
            self.setCircleProgress()
            
            if self.remainingTime ?? 1 < 0 {
                self.setNextStep()
                
                self.setRemainingTime()
                self.setCircleProgress()
            }
        }
    }
    
    func showInitialPomodoroState() -> String? {
        print(selectedWorkspace?.name)
        print(activeWorkspace?.name)
        if selectedWorkspace != nil && (activeWorkspace == nil || selectedWorkspace == activeWorkspace) { return nil }
        
        return "0:0:0"
    }
    
//    func shouldExecuteTimer() -> Bool {
//        return activeWorkspace != nil && selectedWorkspace == activeWorkspace && timerMode == .running
//    }
    
    func setNextStep() {
        timerMode = .initial
        
        switch pomodoroStage {
        case .pomodoro(_):
            pomodoroStage = .shortBreak(60.0 * 0.5)
        case .shortBreak(_), .longBreak(_):
            pomodoroStage = .pomodoro(60.0 * 1.0)
        }
        
        timeElapsed = 0
    }
    
    func changePomodoroStatus(stage: PomodoroStage) {
        pomodoroStage = stage
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
    
    // MARK: Start, Pause, Cancel
    
    func beginSessionWithSelectedWorkspace() {
        activeWorkspace = selectedWorkspace
        print(["Started workspace: ", activeWorkspace?.name])
        timeElapsed = 0
        timerMode = .running
    }
    
    func pauseSession() {
        if selectedWorkspace != activeWorkspace { return }
        
        timerMode = .paused
    }
    
    func endSession() {
        if selectedWorkspace != activeWorkspace { return }
        
        timerMode = .initial
        timeElapsed = 0
    }
    
}
