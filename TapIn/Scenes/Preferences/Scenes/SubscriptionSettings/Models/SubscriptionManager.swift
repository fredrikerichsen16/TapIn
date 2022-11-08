import Foundation
import StoreKit

class SubscriptionManager {
    static var shared = SubscriptionManager()
    private init() {}
    
    func getSubscriptionState() async -> SubscriptionProduct {
        // Fetch products
        do {
            self.products = try await Product.products(for: productIdentifiers)
            
            for product in products {
                switch await product.currentEntitlement
                {
                case .verified(_):
                    if let subscription = SubscriptionProduct(rawValue: product.id) {
                        self.currentSubscription = subscription
                        return subscription
                    }
                default:
                    break
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return .none
    }
    
    let productIdentifiers = Set([SubscriptionID.monthly, SubscriptionID.yearly])
    var products: [Product] = []
    var currentSubscription = SubscriptionProduct.none
}
