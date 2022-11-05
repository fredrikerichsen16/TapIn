import Foundation

enum WorkspaceTab {
    case pomodoro
    case timetracking
    case launcher
    case blocker
    case radio
    case notes
    
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
            
        // Notes is basically excluded because it doesn't have a bottom menu thingy
        case .notes:
            // Safe: self = .notes
            fatalError("This should never happen")
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
        
        // Notes is basically excluded because it doesn't have a bottom menu thingy
        case .notes:
            // Safe: self = .notes
            fatalError("This should never happen")
        }
    }
    
    func hasBottomMenuTool() -> Bool {
        return self != .notes
    }
    
    var label: String {
        switch self
        {
        case .pomodoro:
            return "Pomodoro"
        case .timetracking:
            return "Time Tracker"
        case .launcher:
            return "Launcher"
        case .blocker:
            return "Blocker"
        case .radio:
            return "Radio"
        case .notes:
            return "Scratchpad"
        }
    }
}
