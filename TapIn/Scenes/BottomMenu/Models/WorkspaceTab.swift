import Foundation

enum WorkspaceTab {
    case pomodoro
    case timetracking
    case launcher
    case blocker
    case radio
    
    mutating func next() {
        switch self
        {
        case .pomodoro:
            self = .timetracking
        case .timetracking:
            self = .launcher
        case .launcher:
            self = .blocker
        case .blocker:
            self = .radio
        case .radio:
            self = .pomodoro
        }
    }
    
    mutating func previous() {
        switch self
        {
        case .pomodoro:
            self = .radio
        case .timetracking:
            self = .pomodoro
        case .launcher:
            self = .timetracking
        case .blocker:
            self = .launcher
        case .radio:
            self = .blocker
        }
    }
}
