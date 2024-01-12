import SwiftUI
import RealmSwift
import UserNotifications
import Factory

enum PomodoroButton: String {
    case start = "Start"
    case pause = "Pause"
    case resume = "Resume"
    case cancel = "Cancel"
    case skip = "Skip"
}

class PomodoroStadie {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage = .working(1)
    var status: WorkspaceComponentStatus = false
    var timerMode: TimerMode = .initial
    
    init(pomodoroState: PomodoroState, stage: PomodoroStage) {
        self.pomodoroState = pomodoroState
        self.stage = stage
    }
    
    // MARK: Timer stuff
    func start() {
        fatalError("Not implemented")
    }
    
    func pause() {
        fatalError("Not implemented")
    }
    
    func cancel() {
        fatalError("Not implemented")
    }
    
    func getButtons() -> [PomodoroButton] {
        fatalError("Not implemented")
    }
    
    // MARK: Stage stuff
    
    func completedSession() {
        fatalError("Not implemented")
    }
    
    func getLabel() -> String {
        return stage.getTitle()
    }
    
    func isInBreak() -> Bool {
        return stage.isBreak()
    }
    
    func getStageDuration() -> Double {
        return stage.getDurationInSeconds()
    }
    
    func sendNotification(completed fromStage: PomodoroStage, transitioningTo toStage: PomodoroStage) {
        if fromStage.isBreak() {
            NotificationManager.main.sendSimpleNotification(title: "Break is over", subtitle: "Return to work for \(toStage.getDurationInMinutes()) minutes")
        } else {
            NotificationManager.main.sendSimpleNotification(title: "Completed session", subtitle: "Good job! Now it is time for a \(toStage.getDurationInMinutes()) minute break.")
        }
    }
}

class PomodoroStadieWorkingInitial: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .working(duration))
        self.status = false
        self.timerMode = .initial
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingRunning)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.start]
    }
}

class PomodoroStadieWorkingRunning: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .working(duration))
        self.status = true
        self.timerMode = .running
    }
    
    // MARK: Timer stuff
    override func pause() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingPaused)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.pause, .cancel]
    }
    
    // MARK: Stage stuff
    
    override func completedSession() {
        let workspace = pomodoroState.workspace
        
        let realm = Container.shared.realmManager.callAsFunction().realm
        
        try? realm.write {
            workspace.sessions.append(SessionDB(stage: stage))
        }
        
        let completedStage = stage
        
        if workspace.longBreakDue()
        {
            pomodoroState.setStadie(pomodoroState.pomodoroStadieLongBreakInitial)
        }
        else
        {
            pomodoroState.setStadie(pomodoroState.pomodoroStadieShortBreakInitial)
        }
        
        // Send notification
        let transitioningToStage: PomodoroStage = pomodoroState.pomodoroStadie.stage
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}

class PomodoroStadieWorkingPaused: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .working(duration))
        self.status = true
        self.timerMode = .paused
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingRunning)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.resume, .cancel]
    }
}

class PomodoroStadieShortBreakInitial: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .shortBreak(duration))
        self.status = true
        self.timerMode = .initial
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieShortBreakRunning)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.start, .skip]
    }
}

class PomodoroStadieShortBreakRunning: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .shortBreak(duration))
        self.status = true
        self.timerMode = .running
    }
    
    override func pause() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieShortBreakPaused)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.pause, .skip]
    }
    
    override func completedSession() {
        let completedStage = stage
        
        pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
        
        // Send notification
        let transitioningToStage: PomodoroStage = pomodoroState.pomodoroStadie.stage
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}

class PomodoroStadieShortBreakPaused: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .shortBreak(duration))
        self.status = true
        self.timerMode = .paused
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieShortBreakRunning)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.resume, .skip]
    }
}

class PomodoroStadieLongBreakInitial: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .longBreak(duration))
        self.status = true
        self.timerMode = .initial
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieLongBreakRunning)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.start, .skip]
    }
}

class PomodoroStadieLongBreakRunning: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .longBreak(duration))
        self.status = true
        self.timerMode = .running
    }
    
    override func pause() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieLongBreakPaused)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.pause, .skip]
    }
    
    override func completedSession() {
        let completedStage = stage
        
        pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
        
        // Send notification
        let transitioningToStage: PomodoroStage = pomodoroState.pomodoroStadie.stage
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}

class PomodoroStadieLongBreakPaused: PomodoroStadie {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .longBreak(duration))
        self.status = true
        self.timerMode = .paused
    }
    
    override func start() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieLongBreakRunning)
    }
    
    override func cancel() {
        self.pomodoroState.setStadie(pomodoroState.pomodoroStadieWorkingInitial)
    }
    
    override func getButtons() -> [PomodoroButton] {
        return [.resume, .skip]
    }
}
