import Foundation

enum BlockerError: LocalizedError {
    case blockerStrengthStrict
    case invalidUrl

    var errorDescription: String? {
        switch self
        {
        case .blockerStrengthStrict:
            return "The content blocker strength is strict"
        case .invalidUrl:
            return "Invalid URL"
        }
    }

    var recoverySuggestion: String? {
        switch self
        {
        case .blockerStrengthStrict:
            return "See the settings for this workspace. Lenient blocker = can stop it freely. Normal = can stop it by closing the app. Extreme = can stop it by restarting computer."
        case .invalidUrl:
            return "Type in a valid web URL"
        }
    }
}
