import Foundation

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
    
    func getTitle() -> String {
        switch self
        {
        case .pomodoro(_):
            return "Work Work Work!"
        case .shortBreak(_):
            return "Short Break"
        case .longBreak(_):
            return "Long Break"
        }
    }
    
    func convertToRealmType() -> PomodoroStageRealm {
        switch self
        {
        case .pomodoro(_):
            return .pomodoro
        case .shortBreak(_):
            return .shortBreak
        case .longBreak(_):
            return .longBreak
        }
    }
}
