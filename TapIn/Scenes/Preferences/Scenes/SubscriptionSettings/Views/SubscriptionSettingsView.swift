import SwiftUI
import StoreKit

struct SubscriptionSettingsView: View {
    @StateObject var vm = SubscriptionSettingsState()
    
    func getSubscriptionPeriod(for product: Product) -> String {
        let subscriptionInfo = product.subscription!
        
        switch subscriptionInfo.subscriptionPeriod.unit
        {
        case .month:
            return "monthly"
        case .year:
            return "yearly"
        default:
            return "?!?!?!"
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("TapIn")
                    Text("Pro")
                        .foregroundColor(Color.blue)
                }
                .font(.largeTitle)
                
                Text("Upgrade to TapIn pro to unlock all features and support the continuous development of the app.")
                
                Form {
                    Picker("", selection: $vm.subscriptionPickerSelection) {
                        ForEach(vm.products) { product in
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(product.displayPrice)
                                        .font(.title2)
                                    Text(getSubscriptionPeriod(for: product))
                                }
                                
                                Text(product.description)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.leading, 10)
                            .padding(.vertical, 10)
                            .tag(product.id)
                        }
                    }
                    .pickerStyle(.radioGroup)
                    
                    Spacer().frame(height: 15)
                    
                    Button("Upgrade", action: {
                        vm.purchaseSelectedProduct()
                    })
                    .errorAlert(error: $vm.error)
                }
                
                if let currentSubscription = vm.currentSubscriptionInfo {
                    Text("Active Subscription")
                        .font(.title2)
                    
                    Text("You have an active subscription: \(currentSubscription.product.displayName)")
                    Text("Monthly Price: \(currentSubscription.product.displayPrice)")
                    if let renewalDate = currentSubscription.renewalDate
                    {
                        Text("Will autorenew? \(currentSubscription.willAutoRenew ? "Yes" : "No")")
                        Text("Renewal date: \(renewalDate.formatted())")
                    }
                    
                    Button("Cancel") {
                        print("Cancel")
                    }
                }
                
                Spacer()
            }
            .onAppear {
                vm.fetch()
            }
        }
        .padding()
    }
}

struct SubscriptionSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionSettingsView()
    }
}
