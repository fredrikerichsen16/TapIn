import Foundation

enum TimerMode {
    case initial
    case running
    case paused
    
    func isActive() -> Bool {
        return self != .initial
    }
}
