import SwiftUI
import RealmSwift

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
        self.stage = .working(duration)
    }
    
    func transitionToNextState() {
        if pomodoroState.longBreakDue()
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
