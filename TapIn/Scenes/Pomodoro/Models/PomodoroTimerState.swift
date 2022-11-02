import SwiftUI
import RealmSwift

enum PomodoroButton: String {
    case start = "Start"
    case pause = "Pause"
    case resume = "Resume"
    case cancel = "Cancel"
    case skip = "Skip"
}

// POMODORO TIMER STATES

class PomodoroTimerState {
    var pomodoroState: PomodoroState
    
    init(_ pomodoroState: PomodoroState) {
        self.pomodoroState = pomodoroState
    }
    
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
}

class PomodoroInitialTimerState: PomodoroTimerState {
    override func start() {
        pomodoroState.setTimerState(.running)
    }
    
    override func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.skippedSession()
        }
        else
        {
            fatalError("Should not be possible")
        }
    }
    
    override func getButtons() -> [PomodoroButton] {
        if pomodoroState.stageState.isInBreak()
        {
            return [.start, .skip]
        }
        else
        {
            return [.start]
        }
    }
}

class PomodoroRunningTimerState: PomodoroTimerState {
    override func pause() {
        pomodoroState.setTimerState(.paused)
    }
    
    override func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.skippedSession()
        }
        else
        {
            pomodoroState.setTimerState(.initial)
            pomodoroState.ticker.updateUI()
        }
    }
    
    override func getButtons() -> [PomodoroButton] {
        if pomodoroState.stageState.isInBreak()
        {
            return [.pause, .skip]
        }
        else
        {
            return [.pause, .cancel]
        }
    }
}

final class PomodoroPausedTimerState: PomodoroTimerState {
    override func start() {
        pomodoroState.setTimerState(.running)
    }
    
    override func cancel() {
        if pomodoroState.stageState.isInBreak()
        {
            pomodoroState.skippedSession()
        }
        else
        {
            pomodoroState.setTimerState(.initial)
            pomodoroState.ticker.updateUI()
        }
    }
    
    override func getButtons() -> [PomodoroButton] {
        if pomodoroState.stageState.isInBreak()
        {
            return [.resume, .skip]
        }
        else
        {
            return [.resume, .cancel]
        }
    }
}
