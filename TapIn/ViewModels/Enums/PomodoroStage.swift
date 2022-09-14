import Foundation

enum PomodoroStage {
    case working(Double)
    case shortBreak(Double)
    case longBreak(Double)
    
    func getDuration() -> Double {
        switch self
        {
            case .working(let duration), .shortBreak(let duration), .longBreak(let duration):
                return duration
        }
    }
    
    func getTitle() -> String {
        switch self
        {
        case .working(_):
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
            case .working(_):
                return .pomodoro
            case .shortBreak(_):
                return .shortBreak
            case .longBreak(_):
                return .longBreak
        }
    }
    
    func isInBreak() -> Bool {
        if case .working = self {
            return false
        }
        
        return true
    }
}
