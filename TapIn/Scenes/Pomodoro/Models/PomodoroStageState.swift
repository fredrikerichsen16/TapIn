import SwiftUI
import RealmSwift
import UserNotifications

// POMODORO STAGE STATES

class PomodoroStageState {
    var pomodoroState: PomodoroState
    var stage: PomodoroStage
    
    init(pomodoroState: PomodoroState, stage: PomodoroStage) {
        self.pomodoroState = pomodoroState
        self.stage = stage
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
        let content = UNMutableNotificationContent()
            
        if fromStage.isBreak()
        {
            content.title = "Break is over"
            content.subtitle = "Return to work for \(toStage.getDurationInMinutes()) minutes"
        }
        else
        {
            content.title = "Completed session"
            content.subtitle = "Good job! Now it is time for a \(toStage.getDurationInMinutes()) minute break."
        }
        
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

class PomodoroWorkingStageState: PomodoroStageState {
    init(_ pomodoroState: PomodoroState, duration: Int) {
        super.init(pomodoroState: pomodoroState, stage: .working(duration))
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
