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

struct PomodoroState {
    /*@Published*/ var workspace: WorkspaceDB
    
    var pomodoroDb: PomodoroDB!
    
    // MARK: Pomodoro (put in separate observable object eventually)
    
    /*@Published*/ var remainingTimeString = "00:00"
    /*@Published*/ var circleProgress: Double = 1.0
    
    public var timerMode: TimerMode = .initial
    private var pomodoroStage: PomodoroStage
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init(workspace: WorkspaceDB) {
        self.workspace = workspace
        pomodoroDb = workspace.pomodoro!
        
        pomodoroStage = .pomodoro(60.0 * 0.5) // setInitialStage()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerMode != .running { return }
    
            if Int(self.timeElapsed) % 5 == 0 {
                print(self.description)
            }
            
            self.timeElapsed += 1
            self.updateUI()
            
            if self.remainingTime ?? 1 < 0 {
                self.setNextStage()

                self.updateUI()
            }
        }
    }
    
    mutating func setNextStage() {
        timerMode = .initial

        switch pomodoroStage {
        case .pomodoro(_):
            pomodoroStage = .shortBreak(60.0 * 0.5)
        case .shortBreak(_), .longBreak(_):
            pomodoroStage = .pomodoro(60.0 * 1.0)
        }

        timeElapsed = 0
    }
    
    mutating func updateUI() {
        self.setRemainingTime()
        self.setCircleProgress()
    }
    
    mutating func setRemainingTime() {
        remainingTime = pomodoroStage.getDuration() - timeElapsed
        remainingTimeString = getReadableTime()
    }
    
    mutating func setCircleProgress() {
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
    
    mutating func startSession() {
        print(["Started workspace: ", workspace.name])
        timeElapsed = 0
        timerMode = .running
        
        updateUI()
    }

    mutating func pauseSession() {
        timerMode = .paused
        
        updateUI()
    }
    
    mutating func resumeSession() {
        timerMode = .running
        
        updateUI()
    }

    mutating func cancelSession() {
        timerMode = .initial
        timeElapsed = 0
        
        updateUI()
    }
    
    public var description: String {
        return """
        Timeelapsed: \(timeElapsed)
        pomodoroStage: \(pomodoroStage)
        remainingTimeString \(remainingTimeString)
        """
    }
    
}

class StateManager: ObservableObject {
    
    // MARK: General
    
    @Published var activeWorkspace: WorkspaceDB? = nil
    @Published var selectedWorkspace: WorkspaceDB? = nil {
        didSet {
            guard let ws = selectedWorkspace else { return }
            
            if activeWorkspace != nil && ws == activeWorkspace
            {
                selectedPomodoro = activePomodoro
            }
            else
            {
                selectedPomodoro = PomodoroState(workspace: ws)
            }
        }
    }
    @Published var sidebarSelection: String? = "home"
    
    // MARK: Pomodoro
    
    var activePomodoro: PomodoroState?
    @Published var selectedPomodoro: PomodoroState!
    
}
