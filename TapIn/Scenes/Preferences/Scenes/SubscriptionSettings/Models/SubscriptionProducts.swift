import Foundation

enum SubscriptionProduct: String {
    case none = ""
    case monthly = "com.tapin.monthlysubscription"
    case yearly = "com.tapin.yearlysubscription"
    
    func isPremium() -> Bool {
        switch self
        {
        case .none:
            return false
        case .monthly, .yearly:
            return true
        }
    }
}
