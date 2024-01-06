import SwiftUI
import RealmSwift
import UserNotifications

// POMODORO STAGE STATES

class PomodoroStageState {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage
    var status: WorkspaceComponentStatus
    
    init(pomodoroState: PomodoroState, stage: PomodoroStage) {
        self.pomodoroState = pomodoroState
        self.stage = stage
        self.status = false
    }
    
    func transitionToNextState(withNotification: Bool) {
        fatalError("Not implemented")
    }
    
    func performTransition(fromStage: PomodoroStageState, toStage: PomodoroStageState, withNotification: Bool) {
        pomodoroState.setStageState(toStage)
        pomodoroState.setTimerState(.initial)
        pomodoroState.ticker.updateUI()
        
        if withNotification {
            sendNotification(completed: fromStage.stage, transitioningTo: toStage.stage)
        }
    }
    
    func getLabel() -> String {
        return stage.getTitle()
    }
    
    func isInBreak() -> Bool {
        return stage.isBreak()
    }
    
    func getStageDuration() -> Double {
        return self.stage.getDurationInSeconds()
    }
    
    func sendNotification(completed fromStage: PomodoroStage, transitioningTo toStage: PomodoroStage) {
        if fromStage.isBreak() {
            NotificationManager.main.sendSimpleNotification(title: "Break is over", subtitle: "Return to work for \(toStage.getDurationInMinutes()) minutes")
        } else {
            NotificationManager.main.sendSimpleNotification(title: "Completed session", subtitle: "Good job! Now it is time for a \(toStage.getDurationInMinutes()) minute break.")
        }
    }
}

class PomodoroWorkingStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .working(duration))
        self.status = true
    }
    
    override func transitionToNextState(withNotification: Bool) {
        let fromStage = self
        let toStage: PomodoroStageState
        
        if pomodoroState.longBreakDue() {
            toStage = pomodoroState.longBreakStageState
        } else {
            toStage = pomodoroState.shortBreakStageState
        }
        
        performTransition(fromStage: fromStage, toStage: toStage, withNotification: withNotification)
    }
}

final class PomodoroShortBreakStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .shortBreak(duration))
        self.status = false
    }
    
    override func transitionToNextState(withNotification: Bool) {
        performTransition(fromStage: self, toStage: pomodoroState.workingStageState, withNotification: withNotification)
    }
}

final class PomodoroLongBreakStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .longBreak(duration))
        self.status = false
    }
    
    override func transitionToNextState(withNotification: Bool) {
        performTransition(fromStage: self, toStage: pomodoroState.workingStageState, withNotification: withNotification)
    }
}
