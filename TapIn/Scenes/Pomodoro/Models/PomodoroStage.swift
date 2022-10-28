import RealmSwift
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
    
//    func convertToRealmType() -> PomodoroStageRealm {
//        switch self
//        {
//            case .working(_):
//                return .pomodoro
//            case .shortBreak(_):
//                return .shortBreak
//            case .longBreak(_):
//                return .longBreak
//        }
//    }
    
    func isInBreak() -> Bool {
        if case .working = self {
            return false
        }
        
        return true
    }
}

extension PomodoroStage: FailableCustomPersistable {
    init?(_ label: String) {
        let regexPredicate = NSPredicate(format: "SELF MATCHES[c] %@", argumentArray: ["[A-Za-z]+\\(\\d+\\)"])
        
        if regexPredicate.evaluate(with: label) == false {
            return nil
        }
        
        let name = String(label.split(separator: "(")[0])
        let duration = Double(label.split(separator: "(")[1].dropLast(1))! // using ! because regex should catch any errors
        
        switch name
        {
        case "working":
            self = .working(duration)
        case "shortBreak":
            self = .shortBreak(duration)
        case "longBreak":
            self = .longBreak(duration)
        default:
            return nil
        }
    }
    
    public typealias PersistedType = String
    
    public init?(persistedValue: PersistedType) {
        self.init(persistedValue)
    }
    
    public var persistableValue: PersistedType {
        switch self
        {
        case .working(let duration):
            return "working(\(duration))"
        case .shortBreak(let duration):
            return "shortBreak(\(duration))"
        case .longBreak(let duration):
            return "longBreak(\(duration))"
        }
    }
}
