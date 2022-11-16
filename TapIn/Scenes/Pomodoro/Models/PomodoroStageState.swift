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
        // TODO: This is hte perfect case to use the pattern where you have part of an algorithm in subclasses, namely the ifelse in the middle varies, the stuff around is the same
        
        let completedStage = stage
        
        if pomodoroState.longBreakDue()
        {
            pomodoroState.setStageState(pomodoroState.longBreakStageState)
            pomodoroState.setTimerState(.initial)
            pomodoroState.ticker.updateUI()
        }
        else
        {
            pomodoroState.setStageState(pomodoroState.shortBreakStageState)
            pomodoroState.setTimerState(.initial)
            pomodoroState.ticker.updateUI()
        }
        
        if withNotification == false {
            return
        }
        
        let transitioningToStage: PomodoroStage = pomodoroState.stageState.stage
        
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}

final class PomodoroShortBreakStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .shortBreak(duration))
        self.status = false
    }
    
    override func transitionToNextState(withNotification: Bool) {
        let completedStage = stage
        
        pomodoroState.setStageState(pomodoroState.workingStageState)
        pomodoroState.setTimerState(.initial)
        pomodoroState.ticker.updateUI()
        
        if withNotification == false {
            return
        }
        
        let transitioningToStage: PomodoroStage = pomodoroState.stageState.stage
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}

final class PomodoroLongBreakStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .longBreak(duration))
        self.status = false
    }
    
    override func transitionToNextState(withNotification: Bool) {
        let completedStage = stage
        
        pomodoroState.setStageState(pomodoroState.workingStageState)
        pomodoroState.setTimerState(.initial)
        pomodoroState.ticker.updateUI()
        
        if withNotification == false {
            return
        }
        
        let transitioningToStage: PomodoroStage = pomodoroState.stageState.stage
        sendNotification(completed: completedStage, transitioningTo: transitioningToStage)
    }
}
