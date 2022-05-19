import SwiftUI
import RealmSwift

let divideDurationBy = 1.0

class PomodoroState: ObservableObject {
    @Published var workspace: WorkspaceDB
    
    var pomodoroDb: PomodoroDB
    var realm: Realm
    
    // MARK: Pomodoro (put in separate observable object eventually)
    
    @Published var remainingTimeString = "00:00"
    @Published var circleProgress: Double = 1.0
    
    @Published var timerMode: TimerMode = .initial
    @Published var pomodoroStage: PomodoroStage
    
    private var timer: Timer!
    private var timeElapsed: Double = 0.0
    private var remainingTime: Double? = nil
    
    init(realm: Realm, ws: WorkspaceDB) {
        self.workspace = ws
        self.pomodoroDb = ws.pomodoro!
        self.realm = realm
        
        pomodoroStage = .pomodoro(pomodoroDb.pomodoroDuration / divideDurationBy) // setInitialStage()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if self.timerMode != .running { return }
            
            self.timeElapsed += 1
            self.updateUI()
            
            if self.remainingTime ?? 1 < 0 {
                self.completedSession()

                self.updateUI()
            }
        }
    }
    
    func completedSession() {
        let (thawed, realm) = workspace.easyThaw()
        var numCompletedSessions: Int = 0
    
        try! realm.write {
            thawed.sessions.append(SessionDB(stage: pomodoroStage.convertToRealmType(), duration: pomodoroStage.getDuration()))
            numCompletedSessions = thawed.sessions.count
        }
        
        print("Have completed this many sessions: ")
        print(numCompletedSessions)
        
        print("PRINT INFO")
        for session in thawed.sessions {
            print(session.description)
        }
        
        timerMode = .initial

        switch pomodoroStage {
        case .pomodoro(_):
            if numCompletedSessions % Int(pomodoroDb.longBreakFrequency) == 0 {
                pomodoroStage = .longBreak(pomodoroDb.longBreakDuration / divideDurationBy)
            } else {
                pomodoroStage = .shortBreak(pomodoroDb.shortBreakDuration / divideDurationBy)
            }
        case .shortBreak(_), .longBreak(_):
            pomodoroStage = .pomodoro(pomodoroDb.pomodoroDuration / divideDurationBy)
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
        print(["Started workspace: ", workspace.name])
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
    
    func skipBreak() {
        completedSession()
        
        updateUI()
    }
    
}
