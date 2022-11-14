import Foundation

enum BlockerError: LocalizedError {
    case blockerStrengthStrict

    var errorDescription: String? {
        switch self
        {
        case .blockerStrengthStrict:
            return "The content blocker strength is strict"
        }
    }

    var recoverySuggestion: String? {
        switch self
        {
        case .blockerStrengthStrict:
            return "See the settings for this workspace. Lenient blocker = can stop it freely. Normal = can stop it by closing the app. Extreme = can stop it by restarting computer."
        }
    }
}
