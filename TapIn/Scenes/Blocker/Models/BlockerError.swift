import Foundation

enum BlockerError: LocalizedError {
    case invalidUrl
    case normalStrictnessError
    case extremeStrictnessError(_ date: Date)

    var errorDescription: String? {
        switch self
        {
        case .invalidUrl:
            return "Invalid URL"
        case .normalStrictnessError:
            return "Cannot stop blocker"
        case .extremeStrictnessError(_):
            return "Cannot stop blocker"
        }
    }

    var recoverySuggestion: String? {
        switch self
        {
        case .invalidUrl:
            return "Type in a valid web URL"
        case .normalStrictnessError:
            return "You cannot stop the blocker while a session is active. Set blocker strength to lenient to allow this."
        case .extremeStrictnessError(let date):
            let formatter = DateFormatter()
                formatter.dateFormat = "hh:mm:ss"
            
            let time = formatter.string(from: date)
            
            return "You cannot stop the blocker until \(time) because your blocker strength is set to \"extreme\". The blocker will not stop until the amount of time you initially committed to has elapsed."
        }
    }
}
