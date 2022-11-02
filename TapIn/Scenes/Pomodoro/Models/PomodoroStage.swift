import RealmSwift
import Foundation

enum PomodoroStage {
    case working(Int)
    case shortBreak(Int)
    case longBreak(Int)
    
    func getDurationInSeconds() -> Double {
        switch self
        {
            case .working(let duration), .shortBreak(let duration), .longBreak(let duration):
                return Double(duration) * 60
        }
    }
    
    func getDurationInMinutes() -> Int {
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
    
    func isBreak() -> Bool {
        if case .working = self {
            return false
        }
        
        return true
    }
}
