import SwiftUI
import RealmSwift

// POMODORO TIMER STATES

protocol PomodoroTimerState {
    var pomodoroState: PomodoroState { get set }
    
    init(_ pomodoroState: PomodoroState)
    func start()
    func pause()
    func cancel()
    func getButtons(stage: PomodoroStage) -> AnyView
}

final class PomodoroInitialTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    init(_ pomodoroState: PomodoroState) {
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

final class PomodoroRunningTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    init(_ pomodoroState: PomodoroState) {
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

final class PomodoroPausedTimerState: PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    init(_ pomodoroState: PomodoroState) {
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
