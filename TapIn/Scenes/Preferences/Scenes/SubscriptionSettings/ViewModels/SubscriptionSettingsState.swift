import Foundation
import StoreKit

enum SubscriptionError: LocalizedError {
    case transactionFailed
    case userCancelled
    case alreadyHaveSubscription
    case custom(description: String, recoverySuggestion: String)

    var errorDescription: String? {
        switch self
        {
        case .transactionFailed:
            return "Transaction failed"
        case .userCancelled:
            return "You cancelled the transaction"
        case .alreadyHaveSubscription:
            return "Attempting to upgrade to already active subscription tier"
        case .custom(let description, _):
            return description
        }
    }

    var recoverySuggestion: String? {
        switch self
        {
        case .transactionFailed:
            return "Check your details"
        case .userCancelled:
            return "Stop being poor"
        case .alreadyHaveSubscription:
            return "Did you mean to upgrade/downgrade?"
        case .custom(_, let recoverySuggestion):
            return recoverySuggestion
        }
    }
}

struct CurrentSubscriptionInfo {
    let product: Product
    let willAutoRenew: Bool
    let renewalDate: Date?
    init(product: Product, willAutoRenew: Bool, renewalDate: Date?) {
        self.product = product
        self.willAutoRenew = willAutoRenew
        self.renewalDate = renewalDate
    }
}

class SubscriptionSettingsState: ObservableObject {
    init() {
        self.products = SubscriptionManager.shared.products
        self.currentSubscription = SubscriptionManager.shared.currentSubscription
        self.subscriptionPickerSelection = SubscriptionProduct.monthly.rawValue
                
        for product in products
        {
            if product.id == currentSubscription.rawValue
            {
                currentProduct = product
                break
            }
        }
    }
    
    @Published var currentSubscription: SubscriptionProduct = .none
    @Published var products: [Product]
    @Published var currentProduct: Product? = nil
    @Published var currentSubscriptionInfo: CurrentSubscriptionInfo? = nil
    @Published var subscriptionPickerSelection: String
    
    func purchaseSelectedProduct() {
        guard let product = products.first(where: { $0.id == subscriptionPickerSelection }) else {
            return
        }
        
        if product.id == currentProduct?.id {
            error = SubscriptionError.alreadyHaveSubscription
        }
        
        Task {
            do {
                let result = try await product.purchase(options: [.simulatesAskToBuyInSandbox(true)])
                
                switch result
                {
                case .success(let verificationResult):
                    switch verificationResult
                    {
                    case .verified(_):
                        if let product = SubscriptionProduct(rawValue: product.id) {
                            DispatchQueue.main.async {
                                self.currentSubscription = product
                                UserDefaults.standard.setValue(product.isPremium(), forKey: "subscribed")
                            }
                        }
                    case .unverified(_, _):
                        DispatchQueue.main.async {
                            self.error = SubscriptionError.transactionFailed
                        }
                    }
                case .userCancelled:
                    DispatchQueue.main.async {
                        self.error = SubscriptionError.userCancelled
                    }
                default:
                    break
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = SubscriptionError.custom(description: "Transaction failed", recoverySuggestion: error.localizedDescription)
                }
            }
        }
    }
    
    func fetch() {
        guard
            let product = currentProduct,
            let subscription = product.subscription
        else {
            return
        }
        
        Task {
            guard let status = try? await subscription.status.first else { return }
            
            var willAutoRenew = false
            var renewalDate: Date? = nil
            
            if case .verified(let renewalInfo) = status.renewalInfo {
                willAutoRenew = renewalInfo.willAutoRenew
            }
            
            if let resultingTransaction = await product.latestTransaction,
               case .verified(let transaction) = resultingTransaction {
                renewalDate = transaction.expirationDate
            }
            
            let _willAutoRenew = willAutoRenew
            let _renewalDate = renewalDate
            
            DispatchQueue.main.async {
                self.currentSubscriptionInfo = CurrentSubscriptionInfo(product: product, willAutoRenew: _willAutoRenew, renewalDate: _renewalDate)
            }
        }
    }
    
    // MARK: Errors
    
    @Published var error: Swift.Error? = nil
}

